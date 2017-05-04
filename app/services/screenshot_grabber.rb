require "capybara/dsl"
require "capybara/poltergeist"

class ScreenshotGrabber
  include Capybara::DSL

  attr_reader :url

  def initialize(url)
    @url = url
  end

  def call(timeout = 2)
    setup!
    page.driver.headers = {
      "User-Agent" => user_agent
    }

    visit url
    puts "00000000000000000000000000000000000000000000000000000000000000000000"
    puts page.status_code.to_i
    return false unless valid_status_code?(page.status_code.to_i)
    sleep timeout

    file_name = "#{Dir.tmpdir}/counterfind_screenshot_#{Time.now.to_f}.jpg"
    page.driver.save_screenshot(file_name, screenshot_options)

    file_name
  end

  private

  def setup!
    Capybara.run_server = false
    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(app, {
        phantomjs: Phantomjs.path,
        js_errors: false,
        phantomjs_options: ["--ignore-ssl-errors=yes", "--ssl-protocol=any"]
      })
    end
    Capybara.current_driver = :poltergeist
    Capybara.reset_sessions!
  end

  def user_agent
    "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.43 Safari/537.31"
  end

  def valid_status_code?(code)
    return true if code == 200
    return true if code / 100 == 3
  end

  def screenshot_options
    {
      full: true
    }
  end

  def linux?
    RUBY_PLATFORM.match?(/linux\z/)
  end
end
