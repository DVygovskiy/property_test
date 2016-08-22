require_relative '../page-objects/home_page'
require_relative '../page-objects/results_page'
require 'capybara/cucumber'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'selenium/webdriver'

# initialise all pageobjects
Before do |scenario|
  #Capybara.reset_sessions!
  Capybara.current_session.driver.browser.manage.window.resize_to(1920,1080)
  @test_world = TestWorld.new
  @home = HomePage.new
  @results = ResultsPage.new
end


After do |scenario|
  #Capybara.send(:session_pool).each { |name, ses| ses.driver.quit }
  #Capybara.send(:session_pool).each { |name, ses| ses.reset! }
  if ENV['reset'] == "true"
    Capybara.reset_sessions!
  end
  @test_world.clean
  @test_context = nil
end