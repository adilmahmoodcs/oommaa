# import a single FB "post" (may be post, image or video) and its page
class PostImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(url, user_email)
    object_id, type = FbURLParser.new(url).call
    return unless object_id

    data = case type
    when :photo
      FBPhotoReader.new(object_id: object_id, token: token).call
    when :post
      FBPostReader.new(object_id: object_id, token: token).call
    when :video
      FBVideoReader.new(object_id: object_id, token: token).call
    when :page
      find_or_create_page(object_id)
      return
    end

    return if FacebookPost.exists?(facebook_id: data["id"])

    page = find_or_create_page(data["from"]["id"])
    # create a post from the submitted URL
    find_or_create_post(data, page, user_email)
  end

  private

  def find_or_create_page(object_id)
    data = FBPageReader.new(object_id: object_id, token: token).call

    if page = FacebookPage.find_by(facebook_id: data["id"])
      return page
    end

    page = FacebookPage.create!(
      facebook_id: data["id"],
      name: data["name"],
      url: data["link"],
      image_url: data.dig("picture", "data", "url"),
      brand_ids: matching_brands_for(data["name"]).map(&:id)
    )

    # start import of all page posts
    PostsImporterJob.perform_in(1.minutes, page.id)
    page
  end

  def find_or_create_post(data, page, user_email)
    post = page.facebook_posts.create!(
      facebook_id: data["id"],
      message: data["name"],
      published_at: data["created_time"],
      permalink: data["permalink_url"],
      image_url: data["picture"],
      link: data["link"],
      # we start as blacklisted, but PostStatusJob will also run
      status: "blacklisted",
      blacklisted_at: Time.now,
      blacklisted_by: user_email
    )

    post.parse_all_links!
    # mark its domains as blacklisted
    Domain.blacklist_new_domains!(post.all_domains)
    # this will **probably** keep the post as blacklisted
    PostStatusJob.perform_async(post.id)

    post
  end

  def matching_brands_for(term)
    Brand.select(:id, :name).find_all do |brand|
      term.to_s.match?(/#{brand.name}/i)
    end
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end
end
