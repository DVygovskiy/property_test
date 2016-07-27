require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
Dir['../page-objects/*.rb'].each { |file| require_relative file }
Dir['../helpers/*.rb'].each { |file| require_relative file }
require 'pathname'
require 'pry-nav'
require 'active_support/core_ext/string'
require 'net/http'
require 'net/https'
require_relative '../helpers/email.rb'
require_relative '../helpers/finder.rb'
require_relative '../../features/helpers/email_new'
require_relative '../helpers/api'
require 'rspec'
require_relative '../data_objects/web_data.rb'
require_relative '../data_objects/user.rb'
require 'mysql'


Given(/^the user "([^\"]*)" exists$/) do |user_alias|
  user = User.new
  @test_world.add_user(user_alias, user)
end

When(/^I open the homepage$/) do
  @home.load
end

When(/^I search for "([^\"]*)"/) do |text|
  @home.search text
end

When(/^I search for user "([^"]*)"$/) do |user_alias|
  user = @test_world.get_user user_alias
  @home.search user.name
end

Then(/^I should be on the search results for "([^\"]*)"$/) do |search_text|
  expect(@results.current_url).to include search_text
end

Then(/^I should be on the search results for user "([^"]*)"$/) do |user_alias|
  name = @test_world.get_user(user_alias).name
  expect(@results.current_url).to include name.tr(' ', '+')
end



Then(/^I should see search results for query "([^"]*)"$/) do |user_alias|
  name = @test_world.get_user(user_alias).name
  expect(@results).to have_search_results minimum: 10
  expect(@results.search_results[0]).to have_text name
end

Then(/^I should see a link to "([^"]*)"$/) do |url|
  expect(@results.search_result_links).to include(url)
end


When(/^I open the "([^"]*)" page$/) do |arg|
  @page = Finder.page_class(arg)
  @page.load
  begin
    expect(page).to have_text @page.title
    @current_page = @page
  rescue
    screenshot_and_save_page
  end
end

When(/^I click the "([^"]*)" (link|button|tab)$/) do |text, control|
  if control == 'link'
    selector = text.to_s.downcase + "_link"
  elsif control == 'button'
    selector = text.to_s.downcase + "_button"
  else
    selector = text.to_s.downcase + "_tab"
  end
  selector = selector.gsub(" ", "_")
  @current_page.click_the(Finder.element_of_page(@current_page, selector))
  new_window = page.driver.browser.window_handles.last
  page.driver.browser.switch_to.window(new_window)
  #page.evaluate_script('window.history.back()')

end

Then(/^I am on the "([^"]*)" page$/) do |arg|
  step %(I open the "#{arg}" page)
end

And(/^I type "([^"]*)" into "([^"]*)" field$/) do |text, field|
  selector = field.to_s.downcase + "_field"
  selector = selector.gsub(" ", "_")
  Finder.element_of_page(@current_page, selector).set text
end

Then(/^I login using (Facebook|Linkedin)$/) do |source|
  source = "#{source.downcase}_login"
  @page = class_method(source)
end


And(/^I look for "([^"]*)" within "([^"]*)" table$/) do |element, name_of_table|
  name_of_table = name_of_table.to_s.downcase + "_table"
  test_context[:current_table] = element_of_page(@current_page, name_of_table)
  test_context[:current_row]= @current_page.get_row_from_table(test_context[:current_table], element)
end

And(/^I click the "([^"]*)" it$/) do |action|
  @current_page.make_action_in_table(test_context[:current_row], action)
end


When(/^I return to the "([^"]*)" page$/) do |arg|
  step %(I open the "#{arg}" page)
end

Given(/^I check mailbox "([^"]*)" for "([^"]*)" email$/) do |mailbox, subject|
  adress = mailbox.split("@")[1]
  email = EMAIL_HELPER.new(Capybara.current_session)
  email.check_mailbox(adress, "")
  emails = find(:xpath, ".//*[@class='b-datalist__body']")
  nodes_path = emails.path + "/child::*"
  node = all(:xpath, "#{nodes_path}").detect { |node| node.has_content?("Uw boeking") }
  expect(!node.nil?)
  unless node.nil?
    within(node) do
      find(:xpath, ".//*[@class='b-checkbox__box']").click
    end
  end
  sleep(5)
  #email.delete_all_mailru
  #expect(page).to have_content(subject)
  #email.sign_out(adress)
  #expect(page).not_to have_content(subject)
  #test_context[:current_mail] = adress

end

When(/^I open the "([^"]*)" email$/) do |subject|
  email = EMAIL_HELPER.new(Capybara.current_session)
  email.find_email(test_context[:current_mail], subject)
end

Then(/^I should see the text "([^"]*)"$/) do |text|
  page.should have_content(text)
  expect(page.should have_content(text))
end

And(/^delete "([^"]*)" email$/) do |subject|
  page.find(:xpath, ".//*[@aria-label='Delete']").click
end

Given(/^I loged in as "([^"]*)"$/) do |arg|
  steps (%Q(
          Given I open the "Home" page
          Then I click the "Sing up" button
       ))
  if arg.to_s.include? 'Admin'
    if page.has_text? LoginPage.new.title
      steps(%Q(
                When I am on the "Login" page
                And I type "#{USER[:admin_email]}" into "Email" field
                And I type "#{USER[:admin_password]}" into "Password" field
                And I click the "Login" button
                Then I am on the "Admin" page
      ))
    end
  else
    if page.has_text? LoginPage.new.title
      steps(%Q(
                When I am on the "Login" page
                And I type "#{USER[:valid_email]}" into "Email" field
                And I type "#{USER[:valid_password]}" into "Password" field
                And I click the "Login" button
                Then I am on the "Dashboard" page
      ))
    end
  end
end


And(/^I set up durtion from "([^"]*)" to "([^"]*)"$/) do |s_time, e_time|
  @current_page.set_duration(s_time, e_time)
end

Then(/^I should see (search results|table) with "([^\"]*)"$/) do |group, text|
  selector = text.to_s.downcase + "_search_result"
  if group == "table"
    selector = text.to_s.downcase + "_table"
  end
  expect(Finder.element_of_page(@current_page, selector).visible?)
  test_context[:current_search_results] = Finder.element_of_page(@current_page, selector)
end


And(/^I set up (duration|time) from "([^"]*)" to "([^"]*)" (local|round local)$/) do |no, start, ending, time|
  local_time = Time.now.strftime("%H:%M")
  if time == 'round local'
    if Time.now.min <= 30
      local_time = Time.now.change(:min => 0)
    else
      local_time = Time.now.change(:min => 0) + 3600
    end
  end
  s_time = (local_time + 3600 * (start.to_s.gsub("+", "").to_i)).strftime("%H:%M")
  e_time = (local_time + 3600 * (ending.to_s.gsub("+", "").to_i)).strftime("%H:%M")
  step %(I set up durtion from "#{s_time}" to "#{e_time}")
  test_context[:gigs_s_time] = s_time
  test_context[:gigs_e_time] = e_time
end

And(/^I select "([^"]*)" with name "([^"]*)"$/) do |any, name|
  nodes_path = test_context[:current_search_results].path + "/child::*"
  node = all(:xpath, "#{nodes_path}").detect { |node| node.has_content?(name) }
  expect(!node.nil?)
  unless node.nil?
    within(node) do
      @current_page.click_the(@current_page.select_button)
      new_window = page.driver.browser.window_handles.last
      page.driver.browser.switch_to.window(new_window)
    end
  end
end

And(/^I set up the date to "([^"]*)" days from today$/) do |days|
  date = Time.now
  if days.include? "+"
     date = date + days.to_s.gsub("+", "").to_i * 86400
  else
    date = date - days.to_s.gsub("+", "").to_i * 86400
  end
  date = date.strftime("%d/%m/%Y")
  @current_page.choose_date(date)
  test_context[:gigs_date] = date
end

And(/^I set up date to today$/) do
  step %(I set up the date to "0" days from today)
end


And(/^I select "([^"]*)" to "([^"]*)"$/) do |selection, option|
  selector = selection.to_s.downcase.gsub(" ", "_")
  @current_page.click_the(Finder.element_of_page(@current_page, selector))
  @current_page.click_the(find(:xpath, "//option[contains(text(), '#{option}')]"))
end


And(/^I agree with Terms$/) do
  terms = Finder.element_of_page(@current_page, "terms")
  unless terms.checked?
    @current_page.click_the(terms)
  end
end

And(/^I don't agree with Terms$/) do
  terms = Finder.element_of_page(@current_page, "terms").set(false)
  if terms.checked?
    @current_page.click_the(terms)
  end
end


Given(/^I am connected to mysql$/) do
  mysql = Mysql.new("localhost", "root", "admin", "clevergig_rc")
  binding.pry

  res = mysql.query("SELECT id from users where email = 'clevergig@mail.ru';")
  rows = res.num_rows
  rows.times do
    puts res.fetch_row.join("\s")
  end
  mysql.close
end

#upload image
#find(:xpath, "//input[@id='upload-image']".set("/test/file/path/")
#attach_file("image[upload]", "/test/file/path") - name, id, label

#assert image
#page.has_xpath?("//img[contains(@style, 'bmw_740')]")

And(/^I quick_click "([^"]*)"$/) do |arg|
  @current_page.quick_click(arg)
end

Given(/^API create following GIG:$/) do |table|

  type = table.rows_hash[:type]
  if type == 'not urgent'
    type = 'regular'
  else
    type = 'urgent'
  end
  role = table.rows_hash[:role]
  date = Time.now.strftime("%d/%m/%Y")
  if table.rows_hash[:date].to_s.include? '+'
    date = (Time.now + table.rows_hash[:date].to_s.split(" ")[1].to_i*86400).strftime("%d/%m/%Y")
  elsif table.rows_hash[:date].to_s.include? '-'
    date = (Time.now - table.rows_hash[:date].to_s.split(" ")[1].to_i*86400).strftime("%d/%m/%Y")
  end
  start_time = table.rows_hash[:'start time']
  end_time = table.rows_hash[:'end time']
  local_time = Time.now
  if table.rows_hash[:'start time'].to_s.include? 'round'
    if Time.now.min <= 30
      local_time = Time.now.change(:min => 0)
    else
      local_time = Time.now.change(:min => 0) + 3600
    end
  end
  if table.rows_hash[:'start time'].to_s.include? '+'
    start_time = (local_time + (60*60*table.rows_hash[:'start time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
    end_time = (local_time + (60*60*table.rows_hash[:'end time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
  elsif table.rows_hash[:'start time'].to_s.include? '-'
    start_time = (local_time - (60*60*table.rows_hash[:'start time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
    end_time = (local_time - (60*60*table.rows_hash[:'end time'].to_s.split(" ")[1].to_i)).strftime("%H/%M").gsub('/', ':')
  end
  desc = table.rows_hash[:description]
  v_desc = table.rows_hash[:'venue description']
  location = table.rows_hash[:location]
  @test_context = ["", start_time, end_time]
  API.create_gig(type, role, date, start_time, end_time, desc, v_desc, location)
  binding.pry
end

