# Import new posts from a facebook page
#
# @todo rename to PagePostsImporterJob ?
class PostsImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(page_id)
    page = FacebookPage.find_by(id: page_id)
    unless page
      logger.info "PostsImporterJob: FacebookPage #{page_id} was deleted"
      return
    end

    matching_brand_ids = BrandMatcher.new(page.name).call
    if matching_brand_ids.none?
      logger.info "PostsImporterJob: skipping non-matching FacebookPage #{page.name}"
      self.class.perform_in(3.days, page_id)
      return
    end

    begin
      import_posts(page)
    rescue Koala::Facebook::ClientError => e
      if e.fb_error_code == 4 # Application request limit reached
        logger.info "PostsImporterJob: rate limiting, re-enqueued"
        self.class.perform_in(rand(10..60).minutes, page_id)
        return
      elsif e.fb_error_code == 100
        # make sure it's shut down
        is_shut_down = FBShutDownChecker.new(object_id: page.facebook_id, token: token).call
        if is_shut_down
          page.mark_as_shut_down!
          logger.info "PostsImporterJob: FacebookPage #{page.id} marked as shut down"
          return
        end

        raise e
      end
    end

    self.class.perform_in(60.minutes, page_id)
  end

  private

  def import_posts(page)
    posts_data = FBPostSearcher.new(page_id: page.facebook_id, token: token).call

    posts_data.each do |data|
      data["id"] = data["id"].split("_").last

      # we reached already imported posts...
      break if FacebookPost.exists?(facebook_id: data["id"])
      break if data["message"].blank?

      post = page.facebook_posts.new(
        facebook_id: data["id"],
        message: data["message"],
        published_at: data["created_time"],
        permalink: data["permalink_url"],
        image_url: data["full_picture"],
        link: data["link"],
        likes: data.dig("likes", "summary", "total_count")
      )

      next if post.raw_links.none? # skip posts with no external links

      post.save!
      PostStatusJob.perform_async(post.id)
      logger.info "PostsImporterJob: new FacebookPost #{post.id} created for FacebookPage #{page.id}"
    end
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log/jobs.log'))
  end
end
