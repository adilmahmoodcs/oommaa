class AffiliatePagePostImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts", retry: 5

  def perform(page_id)
    page = FacebookPage.find_by(id: page_id)
    unless page
      logger.info "AffiliatePagePostImporterJob: FacebookPage #{page_id} was deleted"
      return
    end

    begin
      import_posts(page)
    rescue Koala::Facebook::ClientError => e
      if e.fb_error_code == 4 # Application request limit reached
        logger.info "AffiliatePagePostImporterJob: rate limiting, re-enqueued"
        return
      elsif e.fb_error_code == 100
        # make sure it's shut down
        is_shut_down = FBShutDownChecker.new(object_id: page.facebook_id, token: token).call
        if is_shut_down
          page.mark_as_shut_down!
          logger.info "AffiliatePagePostImporterJob: FacebookPage #{page.id} marked as shut down"
          return
        end
      end
      raise e
    end
  end

  private

  def import_posts(page)
    posts_data = FBPostSearcher.new(page_id: page.facebook_id, token: token).call

    posts_data.each do |data|
      data["id"] = data["id"].split("_").last
      # we reached already imported posts...
      break if FacebookPost.exists?(facebook_id: data["id"])

      post = page.facebook_posts.new(
        facebook_id: data["id"],
        message: (data["name"].presence || "<BLANK MESSAGE>"),
        published_at: data["created_time"],
        permalink: data["permalink_url"],
        image_url: data["full_picture"],
        link: data["link"],
        likes: data.dig("likes", "summary", "total_count"),
        status: 'affiliate_greylisted'
      )
      post.save!
      PostScreenshotsJob.perform_async(post.id)
      logger.info "AffiliatePagePostImporterJob: new FacebookPost #{post.id} created for FacebookPage #{page.id}"
    end
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log/jobs.log'))
  end
end
