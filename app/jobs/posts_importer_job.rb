# Import new posts from a facebook page
#
# @todo rename to PagePostsImporterJob ?
class PostsImporterJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(page_id)
    page = FacebookPage.find(page_id)

    begin
      import_posts(page)
    rescue Koala::Facebook::ClientError => e
      # make sure it's shut down
      is_shut_down = FBShutDownChecker.new(object_id: page.facebook_id, token: token).call
      if is_shut_down
        page.mark_as_shut_down!
        logger.info("PostsImporterJob: FacebookPage #{page.id} marked as shut down")
        return
      end

      raise e
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
        link: data["link"]
      )

      next if post.raw_links.none? # skip posts with no external links

      post.save!
      PostStatusJob.perform_async(post.id)
      logger.info("PostsImporterJob: new FacebookPost #{post.id} created for FacebookPage #{page.id}")
    end
  end

  def token
    Rails.configuration.counterfind["facebook"]["tokens"].sample
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log/jobs.log'))
  end
end
