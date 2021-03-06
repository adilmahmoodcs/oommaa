# import a single FB "post" (may be post, image or video) and its page
class PostImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "priority"

  def perform(url, user_email = "user@example.com", brand_ids = [], likes = 0)
    object_id, type = FbURLParser.new(url).call
    return unless object_id # can't parse this URL

    brand_ids = brand_ids.map(&:to_i)

    begin
      data = case type
      when :photo
        FBPhotoReader.new(object_id: object_id, token: token).call
      when :post
        FBPostReader.new(object_id: object_id, token: token).call
      when :video
        FBVideoReader.new(object_id: object_id, token: token).call
      else # type not supported
        return
      end
    rescue Koala::Facebook::ClientError => e
      # try to understand the problem from facebook error codes and messages...
      case e.fb_error_code
      when 4 # API Too Many Calls
        logger.info "PostImporterJob: rate limiting, re-enqueued"
        self.class.perform_in(rand(10..60).minutes, url, user_email, brand_ids)
        return
      when 100
        # so it's a photo...
        if e.message.match?(/nonexisting field.*type \(Photo\)/i)
          data = FBPhotoReader.new(object_id: object_id, token: token).call
        # so it's a post...
        elsif e.message.match?(/nonexisting field.*type \(Post\)/i)
          data = FBPostReader.new(object_id: object_id, token: token).call
        # cannot read for some reason (deleted? old?)
        elsif e.message.match?(/Object with ID .* does not exist/i)
          logger.info "PostImporterJob: skipping, cannot read URL: #{url}"
          return
        else
          raise e
        end
      when 12
        logger.info "PostImporterJob: skipping, single URL not supported: #{url}"
        return
      else
        raise e
      end
    end

    # sometimes facebook IDs are like `page-id_post-id`...
    data["id"] = data["id"].split("_").last

    # we already have this post
    return if FacebookPost.exists?(facebook_id: data["id"])

    # create page if doesn't exists
    page = find_or_create_page(data["from"]["id"], brand_ids)
    # create a post from the submitted URL
    create_post(data, page, user_email, brand_ids)
  end

  private

  def find_or_create_page(object_id, brand_ids)
    data = FBPageReader.new(object_id: object_id, token: token).call

    # if we already have the page, just update page brands
    if page = FacebookPage.find_by(facebook_id: data["id"])
      brand_ids.each do |brand_id|
        unless brand_id.in?(page.brand_ids)
          brand = Brand.find(brand_id)
          page.brands << brand
          page.save!
          logger.info "PostImporterJob: Brand ##{brand_id} added to FacebookPage #{page.id}"
        end
      end
      return page
    end

    # find brands that matches the page name
    matching_brand_ids = BrandMatcher.new(data["name"]).call
    # also add submitted brands
    all_brand_ids = (brand_ids + matching_brand_ids).uniq.compact

    page = FacebookPage.create!(
      facebook_id: data["id"],
      name: data["name"],
      url: data["link"],
      image_url: data.dig("picture", "data", "url"),
      brand_ids: all_brand_ids
    )

    logger.info "PostImporterJob: created new FacebookPage #{page.id}"
    page
  end

  def create_post(data, page, user_email, brand_ids)
    post = page.facebook_posts.create!(
      facebook_id: data["id"],
      message: (data["name"].presence || "<BLANK MESSAGE>"),
      published_at: data["created_time"],
      permalink: data["permalink_url"],
      image_url: data["picture"],
      link: data["link"],
      status: "blacklisted", # we start blacklisted, but PostStatusJob will also run
      blacklisted_at: Time.now,
      blacklisted_by: user_email,
      added_by: user_email,
      likes: data.dig("likes", "summary", "total_count")
    )

    post.parse_all_links!
    # mark its domains as blacklisted
    Domain.blacklist_new_domains!(post.all_domains)
    # this will **probably** keep the post as blacklisted
    PostStatusJob.perform_async(post.id)
    # import screenshots
    PostScreenshotsJob.perform_async(post.id)
    logger.info "PostImporterJob: created new FacebookPost #{post.id}"

    brand_ids.each do |brand_id|
      page_brand = post.facebook_page.facebook_page_brands.find_or_initialize_by(brand_id: brand_id)
      page_brand.facebook_page_post_brands.new(facebook_post: post)
      page_brand.save
    end
    post
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log/jobs.log'))
  end
end
