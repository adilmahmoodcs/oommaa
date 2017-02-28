# saves screenshots of a Facebook Post
class PostScreenshotsJob
  include Sidekiq::Worker
  sidekiq_options queue: "posts"

  def perform(post_id)
    post = FacebookPost.find(post_id)
    return if post.screenshots.any?

    post.parse_all_links! if post.all_links.none?

    save_screenshot!(post, post.permalink, AdScreenshot)
    post.all_links.each do |link|
      save_screenshot!(post, link, ProductScreenshot)
    end

    true
  end

  private

  def save_screenshot!(post, url, klass)
    tmp_file_name = ScreenshotGrabber.new(url).call
    return unless tmp_file_name

    screenshot = klass.new
    screenshot.facebook_post = post
    screenshot.image = File.open(tmp_file_name)
    screenshot.save!

    # File.unlink(tmp_file_name)
  end
end
