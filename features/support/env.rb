
require 'allure-cucumber'
require 'capybara-screenshot/cucumber'
require_relative '../../config/requirements'

#Dotenv.load # loads environment variables from .env file

@default_capybara_driver = :chrome

#Chrome
def setup_chrome
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome)
  end
  Capybara::Screenshot.register_driver(:chrome) do |driver, path|
    driver.browser.save_screenshot(path)
  end
  Capybara.configure do |config|
    config.default_driver = :chrome
    config.javascript_driver = :chrome
    config.run_server = false
    config.default_selector = :xpath
    config.default_max_wait_time = 5
    # capybara 2.1 config options
    config.match = :prefer_exact
    config.ignore_hidden_elements = false
  end
end

def setup_safari
  Capybara.default_driver = :safari
  Capybara.javascript_driver = :safari
  Capybara.default_max_wait_time = 10
  Capybara::Screenshot.register_driver(:safari) do |driver, path|
    driver.browser.save_screenshot(path)
  end
  Capybara.register_driver :safari do |app|
    options = {
        :js_errors => false,
        :timeout => 360,
        :debug => false,
        :inspector => false,
    }

    Capybara::Selenium::Driver.new(app, :browser => :safari)

  end
end

def setup_ie
  Capybara.app_host = "http://10.211.55.3:5555/wd/hub"
  Capybara.default_driver = :selenium
  Capybara::Screenshot.register_driver(:internet_explorer) do |driver, path|
    driver.browser.save_screenshot(path)
  end
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app,
                                   :browser => :remote,
                                   :url => "http://10.211.55.3:5555/wd/hub",
                                   :desired_capabilities => :internet_explorer)
  end
end


def setup_firefox
  Capybara.register_driver :selenium do |app|
    #firefox_paths = %x[mdfind "kMDItemFSName = Firefox.app"]
    #firefox_path = firefox_paths.split('\n').first.chomp
    #firefox_executable_path = File.join(firefox_path, '/Contents/MacOS/firefox')
    #Selenium::WebDriver::Firefox::Binary.path=firefox_executable_path

    #profile = Selenium::WebDriver::Firefox::Profile.new
    #profile['browser.cache.disk.enable'] = false
    #profile['browser.cache.memory.enable'] = false
    #profile['browser.startup.homepage_override.mstone'] = 'ignore'
    #profile['startup.homepage_welcome_url.additional'] = 'about:blank'
    #Selenium::WebDriver::Firefox::Binary.path = "/Applications/Firefox.app/Contents/MacOS/firefox"
    Capybara::Selenium::Driver.new(app, browser: :firefox, marionette: true)
  end
end



def test_context
  @test_context ||= Hash.new
end


AllureCucumber.configure do |config|
  config.output_dir = 'allure'
end


Capybara.default_driver = case ENV['DRIVER']
                          when 'firefox' then :selenium
                          when 'chrome' then  :chrome
                          when 'safari' then :safari
                          when 'ie' then :internet_explorer
                          else @default_capybara_driver
                          end

case ENV['DRIVER']
  when 'firefox' then setup_firefox
  when 'chrome' then  setup_chrome
  when 'safari' then setup_safari
  when 'ie' then setup_ie
  else setup_chrome
end





