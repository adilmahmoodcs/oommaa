# saves screenshots of a Facebook Post
class PostScreenshotsJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(post_id)
    post = FacebookPost.find(post_id)
    return if post.screenshots.any?

    post.parse_all_links! if post.all_links.none?

    post.all_links.each do |link|
      klass = facebook?(link) ? AdScreenshot : ProductScreenshot
      tmp_file_name = ScreenshotGrabber.new(link).call
      return unless tmp_file_name

      screenshot = klass.new
      screenshot.facebook_post = post
      screenshot.image = File.open(tmp_file_name)
      screenshot.save!

      # File.unlink(tmp_file_name)
    end
  end

  private

  def facebook?(url)
    url.match?(/https\:\/\/www\.facebook\.com\//)
  end
end
