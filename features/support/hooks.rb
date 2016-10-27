require_relative '../page-objects/home_page'
require_relative '../page-objects/results_page'
require 'capybara/cucumber'
require 'capybara'
require 'capybara/dsl'
require 'capybara/poltergeist'
require 'selenium/webdriver'

# initialise all pageobjects
Before do |scenario|
  @test_context ||= Hash.new
  #Capybara.current_session.reset!
  #Capybara.current_session.driver.browser.manage.window.resize_to(1920,1080)
end


After do |scenario|
  Capybara.current_session.driver.browser.manage.delete_all_cookies
  if(scenario.failed?)
    time = Time.now.strftime('%Y_%m_%d_%H_%M_%S_')
    name_of_scenario = time + scenario.name.gsub(/\s+/, "_").gsub("/","_")
    puts "Name of snapshot is #{name_of_scenario}"
    file_path = File.expand_path("../screenshots",__FILE__)+'/'+name_of_scenario +'.png'
    page.driver.browser.save_screenshot file_path
    puts "Snapshot is taken"
    puts "#===========================================================#"
    puts "Scenario:: #{scenario.name}"
    puts "#===========================================================#"
  end
  Capybara.send(:session_pool).each { |name, ses| ses.driver.quit }
  #Capybara.reset_sessions!
  @test_context = nil
end