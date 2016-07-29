require_relative '../page-objects/home_page'
require_relative '../page-objects/results_page'
require 'capybara/cucumber'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'selenium/webdriver'

# initialise all pageobjects
Before do
  Capybara.reset_sessions!
  Capybara.current_session.driver.browser.manage.window.resize_to(1920,1080)
  @test_world = TestWorld.new
  @home = HomePage.new
  @results = ResultsPage.new
end


After do
  Capybara.send(:session_pool).each { |name, ses| ses.driver.quit }
  Capybara.send(:session_pool).each { |name, ses| ses.reset! }
end

After do |scenario|
  Capybara.reset_sessions!
  @test_world.clean
  @test_context = nil
end