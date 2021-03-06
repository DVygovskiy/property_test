require_relative '../../config/requirements'


When(/^I open the "([^"]*)" page$/) do |arg|
  @page = Finder.page_class(arg)
  @page.open
  @current_page = @page
end

Then(/^I am on the "([^"]*)" page$/) do |arg|
  step %(I open the "#{arg}" page)
end


When(/^I return to the "([^"]*)" page$/) do |arg|
  step %(I open the "#{arg}" page)
end

Then(/^I am redirected to "([^"]*)" page$/) do |arg|
  step %(I open the "#{arg}" page)
end

Then(/^I go back$/) do
  page.evaluate_script('window.history.back()')
  if page.has_text? @current_page.title
    page.evaluate_script('window.history.back()')
  end
  page.driver.browser.navigate.refresh
end

And(/^I fill in form as follows:$/) do |table|
  table.rows_hash.keys.each do |key|
    text = table.rows_hash[key]
    if key.to_s.include? "set up the date"
      if text.to_s.include? "from"
        text = text.split[1]
        step %(I set up the date to "#{text}" days from today)
      else
        step %(I set up the date to today)
      end
    elsif (key.to_s.include? "set up duration") || (key.to_s.include? "set up time")
      step %(I set up duration #{text})
    elsif key.to_s.include? "checkbox"
      if key.to_s.include? "uncheck"
        step %(I uncheck "#{text}" checkbox)
      else
        step %(I check "#{text}" checkbox)
      end
    elsif key.to_s.include? "image"
      step %(I upload "#{text}" image as "#{key.to_s.gsub(" image", "")}")
    elsif key.to_s.include? "select"
      key = key.to_s.gsub("select ", "")
      step %(I select "#{key}" to "#{text}")
    elsif (key.to_s.include? "change")
      key = key.to_s.gsub("change ", "")
      step %(I select "#{key}" to "#{text}")
    elsif (key.to_s.include? "select")
      key = key.to_s.gsub("select ", "")
      step %(I select "#{key}" to "#{text}")
    else
      step %(I type "#{text}" into "#{key}" field)
    end
  end
end

When(/^I click the "([^"]*)" (link|button|tab)$/) do |text, control|
  ClickableControl.new(control, text, @current_page).click
end


And(/^I type "([^"]*)" into "([^"]*)" field$/) do |text, field|
  TextField.new(field, @current_page).set_text text
end

Then(/^I login using (Facebook|Linkedin)$/) do |source|
  source = "#{source.downcase}_login"
  @page = class_method(source)
end

When(/^I go to the customer's email$/) do
  sleep(15)
  @current_page = Email.new
  @current_page.sign_in(Global.settings.customer_email)
end


Given(/^I check customer's mailbox for "([^"]*)" email$/) do |subject|
  step %(I go to the customer's email)
  step %(I look for the first "email" with "#{subject}" title within "Emails" table)
end

When(/^I open the "([^"]*)" email$/) do |subject|
  @current_page.quick_click(subject)
end

Then(/^I should see the text "([^"]*)"$/) do |text|
  expect(page).to have_text text
end

And(/^Such data should be displayed:$/) do |table|
  table.rows_hash.keys.each do |key|
    text = table.rows_hash[key]
    expect(page).to have_text text
  end
end


#Very similar to Step above, the only difference is that One does not need to specify names of fields/data etc.
#Just list the necessary data
And(/^I should see such info|data|results:$/) do |table|
  table.transpose.raw[0].each do |text|
    if page.has_text? text
      expect(page).to have_text text
    else
      expect(page).to have_xpath("//*[@value='#{text}']")
    end
  end
end


Given(/^I logged in as "([^"]*)"$/) do |arg|
  steps (%Q(
          Given I open the "Home" page
          Then I click the "Sign up" button
       ))
  if arg.to_s.include? 'Admin'
    if page.has_text? LoginPage.new.title
      steps(%Q(
                When I am on the "Login" page
                And I type "#{Global.settings.admin_email}" into "Email" field
                And I type "#{Global.settings.admin_password}" into "Password" field
                And I click the "Login" button
                Then I am on the "Admin" page
      ))
    elsif page.has_text? DashboardPage.new.title
      steps (%Q(
          Given I am on the "Dashboard" page
          Then I click the "Menu" tab
          And I click the "Logout" button
          When I am on the "Login" page
          And I type "#{Global.settings.admin_email}" into "Email" field
                And I type "#{Global.settings.admin_password}" into "Password" field
          And I click the "Login" button
          Then I am on the "Admin" page
       ))
    end
  else
    if page.has_text? LoginPage.new.title
      steps(%Q(
                When I am on the "Login" page
                And I type "#{Global.settings.customer_email}" into "Email" field
                And I type "#{Global.settings.customer_password}" into "Password" field
                And I click the "Login" button
                Then I am on the "Dashboard" page
      ))
    end
  end
end


And(/^I set up duration from "([^"]*)" to "([^"]*)"$/) do |s_time, e_time|
  if test_context[:start_input]!= nil
    start = test_context[:start_input]
    finish = test_context[:end_input]
  else
    start = Finder.element_of_page(@current_page, "start_time")
    finish = Finder.element_of_page(@current_page, "end_time")
  end
  start.click
  start.set s_time
  start.find(:xpath, "./*[text()='#{s_time}']").click
  finish.click
  finish.set e_time
  finish.find(:xpath, "./*[text()='#{e_time}']").click
end


And(/^I set up (duration|time) from "([^"]*)" to "([^"]*)" (local|round local)$/) do |no, start, ending, time|
  local_time = Time.now
  if time == 'round local'
    if Time.now.min <= 30
      local_time = Time.now.change(:min => 0)
    else
      local_time = Time.now.change(:min => 0) + 3600
    end
  end
  if start.to_s.include? "+"
    s_time = (local_time + 3600 * (start.to_s.gsub("+", "").to_i)).strftime("%H:%M")
  elsif start.to_s.include? "-"
    s_time = (local_time - 3600 * (start.to_s.gsub("-", "").to_i)).strftime("%H:%M")
  else
    s_time = start
  end
  if ending.to_s.include? "+"
    e_time = (local_time + 3600 * (ending.to_s.gsub("+", "").to_i)).strftime("%H:%M")
  elsif ending.to_s.include? "-"
    e_time = (local_time - 3600 * (ending.to_s.gsub("+", "").to_i)).strftime("%H:%M")
  else
    e_time = ending
  end

  step %(I set up duration from "#{s_time}" to "#{e_time}")
  test_context[:gigs_s_time] = s_time
  test_context[:gigs_e_time] = e_time
end

And(/^I set up table of timings as:$/) do |table|
  start_t = Finder.all_elements_of_page(@current_page, "start_time")
  end_t = Finder.all_elements_of_page(@current_page, "end_time")
  table.transpose.raw[0].each.with_index do |text, i|
    test_context[:start_input] = start_t[i]
    test_context[:end_input] = end_t[i]
    test_context[:i] = i
    step %(I set up duration #{text})
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
  (Finder.element_of_page(@current_page, "date_picker")).set date
  test_context[:gigs_date] = date
  sleep(0.5)
end

And(/^I set up the date to today$/) do
  step %(I set up the date to "0" days from today)
end


And(/^I select "([^"]*)" to "([^"]*)"$/) do |selection, option|
  selector = selection.to_s.downcase.gsub(" ", "_")
  if @current_page.has_selector? ("//*[contains(text(), '#{option}')]")
    if find("//*[contains(text(), '#{option}')]").visible?
      Finder.element_of_page(@current_page, selector).find(:xpath, "//*[contains(text(), '#{option}')]").click
    end
  else
    @current_page.click_the(Finder.element_of_page(@current_page, selector))
    sleep(0.5)
    if Finder.element_of_page(@current_page, selector).has_xpath? "//*[contains(text(), '#{option}')]"
      @current_page.click_the(find(:xpath, "//*[contains(text(), '#{option}')]"))
    else
      Finder.element_of_page(@current_page, selector).set option
      sleep(0.5)
      Finder.element_of_page(@current_page, selector).native.send_keys(:return)
    end
  end
  sleep(0.5)
end

And(/^I select ([^"]*) with ([^"]*) "([^"]*)" from "([^"]*)" dropdown$/) do |any, any2, value, dropdown|
  step %(I select "#{dropdown}" to "#{value}")
end


And(/^I change "([^"]*)" to "([^"]*)"$/) do |selection, option|
  step %(I select "#{selection}" to "#{option}")
end

And(/^I check "([^"]*)" checkbox$/) do |locator|
  Checkbox.new(locator, @current_page).check
end

And(/^I uncheck "([^"]*)" checkbox$/) do |locator|
  Checkbox.new(locator, @current_page).uncheck
end

Given(/^I am connected to mysql$/) do
  DB.connect()
  binding.pry
end

And(/^I click "([^"]*)" ([^"]*)$/) do |arg, any|
  @current_page.quick_click(arg)
end


And(/^It's ([^"]*) is "([^"]*)"$/) do |any, text|
  expect(test_context[:current_row].has_text? text)
end

Given(/^I resize window to "([^"]*)"$/) do |arg|
  x = arg.to_s.split("x")[0]
  y = arg.to_s.split("x")[1]
  Capybara.current_session.driver.browser.manage.window.resize_to(x, y)
end

And(/^I upload "([^"]*)" image as "([^"]*)"$/) do |name, where|
  image = Image.new(where, @current_page, self)
  image.upload(name)
end



Then(/^I see pop up with "([^"]*)" text$/) do |text|
  expect(page.should have_content(text))

end

And(/^I sleep$/) do
  sleep(5)
  #binding.pry
end

And(/^I drop "([^"]*)" to "([^"]*)" dropzone$/) do |image, where|
  selector = where.to_s.downcase.gsub(" ", "_") + "_image"
  locator = Finder.locator(@current_page, selector)
  @current_page.drop_image(locator, image)
  sleep(3)
end

And(/^I should see the ([^"]*)$/) do |element|
  selector = element.to_s.downcase.gsub(" ", "_")
  expect(Finder.element_of_page(@current_page, selector).visible?)
end

And(/^I choose month ([^"]*)$/) do |month|
  Calendar.new(@current_page).define_month(month.to_s.downcase)
end

Then(/^I set dates:$/) do |table|
  Calendar.new(@current_page).set_dates(table)
end


And(/^I accept pop up message$/) do
  page.driver.browser.switch_to.alert.accept
end

And(/^I take a screenshot$/) do
  file_path = File.expand_path("../../support/screenshots", __FILE__)+"/#{page.title.to_s.gsub(" ", "")}.png"
  page.driver.browser.save_screenshot file_path
end

And(/^I set up value to "([^"]*)" wheel as "([^"]*)"$/) do |name, value|
  Wheel.new(name, @current_page).set_value value
end


And(/^I set "([^"]*)" into "([^"]*)" field$/) do |value, name|
  TextField.new(name, @current_page).set value
end