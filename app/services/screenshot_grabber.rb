require "capybara/dsl"
require "capybara/poltergeist"

class ScreenshotGrabber
  include Capybara::DSL

  attr_reader :url

  EMAIL = 'codecops45@gmail.com'
  PASSWORD = "admin@123"

  def initialize(url)
    @url = url
    setup!
    page.driver.headers = {
      "User-Agent" => user_agent
    }
    login_to_fb
  end

  def call(timeout = 2)

    visit url
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

  def login_to_fb
    visit "http://www.facebook.com"
    fill_in_facebook_form(EMAIL, PASSWORD) if page.has_css?('#loginbutton')
  end

  def fill_in_facebook_form(email, password)
    fill_in('email', :with => email)
    fill_in('pass', :with => password)
    find('#loginbutton').click
  end
end
