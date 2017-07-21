class Browser

  require 'selenium-webdriver'
  require 'capybara'
  require 'byebug'

  def self.set_config
    # configure chrome driver
    # See also: https://robots.thoughtbot.com/headless-feature-specs-with-chrome
    Capybara.register_driver :chrome do |app|
      Capybara::Selenium::Driver.new(app, browser: :chrome)
    end
    Capybara.register_driver :headless_chrome do |app|
      capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
        chromeOptions: { args: %w(headless disable-gpu) }
      )
      Capybara::Selenium::Driver.new app,
        browser: :chrome,
        desired_capabilities: capabilities
    end
    Capybara.javascript_driver = :headless_chrome
    Capybara.default_max_wait_time = 5
  end

  def self.new(driver)
    set_config
    return Capybara::Session.new(driver)
  end

end
