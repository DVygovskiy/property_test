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
  if(scenario.failed?)
    time = Time.now.strftime('%Y_%m_%d_%Y_%H_%M_%S_')
    name_of_scenario = time + scenario.name.gsub(/\s+/, "_").gsub("/","_")
    puts "Name of snapshot is #{name_of_scenario}"
    file_path = File.expand_path("../screenshots",__FILE__)+'/'+name_of_scenario +'.png'
    page.driver.browser.save_screenshot file_path
    puts "Snapshot is taken"
    puts "#===========================================================#"
    puts "Scenario:: #{scenario.name}"
    puts "#===========================================================#"
  end
  #Capybara.send(:session_pool).each { |name, ses| ses.driver.quit }
  #Capybara.send(:session_pool).each { |name, ses| ses.reset! }
  if ENV['reset'] == "true"
    Capybara.reset_sessions!
  end
  @test_world.clean
  @test_context = nil
end
Cucumber::RunningTestCase::Scenario
Cucumber::Core::Test::Case
Cucumber::Core::Test::Step