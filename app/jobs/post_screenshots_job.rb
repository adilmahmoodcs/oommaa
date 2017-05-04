# saves screenshots of a Facebook Post
class PostScreenshotsJob
  include Sidekiq::Worker
  sidekiq_options queue: "not_facebook", retry: 5

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
    begin
      tmp_file_name = ScreenshotGrabber.new(url).call
      # Try again if any issue proceed
      unless tmp_file_name
        tmp_file_name = ScreenshotGrabber.new(url).call
      end
      return unless tmp_file_name

      screenshot = klass.new
      screenshot.facebook_post = post
      screenshot.image = File.open(tmp_file_name)
      screenshot.save!

      # File.unlink(tmp_file_name)
      logger.info "PostScreenshotsJob: saved #{screenshot.image.url}"
    rescue Capybara::Poltergeist::StatusFailError,
           Capybara::Poltergeist::BrowserError,
           Capybara::Poltergeist::DeadClient,
           Capybara::Poltergeist::TimeoutError,
           Errno::EPIPE => e
      logger.error "PostScreenshotsJob: Capybara error for url #{url}: #{e.message.inspect}"
      raise "Error occurred in job please review the (log/jobs.log) file for details"
    end
  end

  def logger
    @logger ||= Logger.new(Rails.root.join('log/jobs.log'))
  end
end
