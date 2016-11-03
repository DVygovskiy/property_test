require_relative '../../config/requirements'


When(/^I open the "([^"]*)" page$/) do |arg|
  @page = Finder.page_class(arg)
  if @page.url != ""
    @page.load
  end
  begin
    new_window = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window(new_window)
    expect(page).to have_text @page.title
    @current_page = @page
  rescue
    screenshot_and_save_page
  end
end

Then(/^I am on the "([^"]*)" page$/) do |arg|
  step %(I open the "#{arg}" page)
end


When(/^I return to the "([^"]*)" page$/) do |arg|
  step %(I open the "#{arg}" page)
  if page.driver.browser.window_handles.first !=page.driver.browser.window_handles.last
    old_window = page.driver.browser.window_handles.first
    page.driver.browser.switch_to.window(old_window)
    Capybara.current_session.current_window.close
    back = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window(back)
  end
end

Then(/^I am redirected to "([^"]*)" page$/) do |arg|
  step %(I open the "#{arg}" page)
  if page.driver.browser.window_handles.first !=page.driver.browser.window_handles.last
    old_window = page.driver.browser.window_handles.first
    page.driver.browser.switch_to.window(old_window)
    Capybara.current_session.current_window.close
    back = page.driver.browser.window_handles.last
    page.driver.browser.switch_to.window(back)
  end
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
      step %(I upload "#{text}" image as "#{key}")
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
  sleep(0.5)
end


And(/^I type "([^"]*)" into "([^"]*)" field$/) do |text, field|
  TextField.new(field, @current_page).set_text text
end

Then(/^I login using (Facebook|Linkedin)$/) do |source|
  source = "#{source.downcase}_login"
  @page = class_method(source)
end


And(/^I look for "([^"]*)" within "([^"]*)" table$/) do |element, name_of_table|
  name_of_table = name_of_table.to_s.downcase + "_table"
  test_context[:current_table] = Finder.element_of_page(@current_page, name_of_table)
  test_context[:current_row]= @current_page.find_from_table(test_context[:current_table], element)
  expect(!test_context[:current_row].nil?)
end

And(/^I look for the first "([^"]*)" with "([^"]*)" ([^"]*) within "([^"]*)" table$/) do |any, arg, any2, name_of_table|
  name_of_table = name_of_table.to_s.downcase + "_table"
  test_context[:current_table] = Finder.element_of_page(@current_page, name_of_table)
  test_context[:current_row]= @current_page.find_first_from_table(test_context[:current_table], arg)
  expect(!test_context[:current_row].nil?)
  test_context[:current_row_path] = test_context[:current_row].path
end

And(/^I look for the "([^"]*)" with "([^"]*)" ([^"]*) within "([^"]*)" table$/) do |any, arg, any2, name_of_table|
  name_of_table = name_of_table.to_s.downcase + "_table"
  test_context[:current_table] = Finder.element_of_page(@current_page, name_of_table)
  test_context[:current_row]= @current_page.find_first_from_table(test_context[:current_table], arg)
  expect(!test_context[:current_row].nil?)
  test_context[:current_row_path] = test_context[:current_row].path
end

And(/^I click the "([^"]*)" it$/) do |action|
  @current_page.make_action_in_table(test_context[:current_row], action)
  sleep(3)
end


Given(/^I check mailbox "([^"]*)" for "([^"]*)" email$/) do |mailbox, subject|
  sleep(10)
  adress = mailbox.split("@")[1]
  email = EMAIL_HELPER.new(self)
  email.check_mailbox(adress, "")
  emails = find(:xpath, ".//*[@class='b-datalist__body']")
  nodes_path = emails.path + "/child::*"
  node = all(:xpath, "#{nodes_path}").detect { |node| node.has_content?("#{subject}") }
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
  test_context[:current_mail] = adress

end

When(/^I open the "([^"]*)" email$/) do |subject|
  email = EMAIL_HELPER.new(self)
  email.find_email(test_context[:current_mail], subject)
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
          Then I click the "Sing up" button
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
    begin
      test_context[:start_input].native.send_keys(:return)
      find(:xpath, "//*[text()='#{s_time}']", :visible => true).click
      find(:xpath, "//*[text()='#{e_time}']", :visible => true).click
    rescue
    end
  else
    (Finder.element_of_page(@current_page, "start_time")).set s_time
    (Finder.element_of_page(@current_page, "end_time")).set e_time
    find(:xpath, "//*[text()='#{e_time}']", :visible => true).click
  end
end

Then(/^I should see (search results|table) with "([^\"]*)"$/) do |group, text|
  selector = text.to_s.downcase + "_search_result"
  if group == "table"
    selector = text.to_s.downcase + "_table"
  end
  begin
    expect(Finder.element_of_page(@current_page, selector).visible?)
    test_context[:current_search_results] = Finder.element_of_page(@current_page, selector)
  rescue
    puts "There is no visible results/table"
    test_context[:current_search_results] = "null"
  end
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


And(/^I select "([^"]*)" with ([^"]*) "([^"]*)"$/) do |any, arg, name|
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
  (Finder.element_of_page(@current_page, "date_picker")).set date
  test_context[:gigs_date] = date
  sleep(0.5)
end

And(/^I set up the date to today$/) do
  step %(I set up the date to "0" days from today)
end


And(/^I select "([^"]*)" to "([^"]*)"$/) do |selection, option|
  selector = selection.to_s.downcase.gsub(" ", "_")
  @current_page.click_the(Finder.element_of_page(@current_page, selector))
  sleep(0.5)
  if page.has_xpath? "//*[contains(text(), '#{option}')]"
    @current_page.click_the(find(:xpath, "//*[contains(text(), '#{option}')]"))
    begin
      find(:xpath, "//*[contains(text(), '#{option}')]").native.send_keys(:return)
    rescue
    end
  else
    Finder.element_of_page(@current_page, selector).set option
    sleep(0.5)
    Finder.element_of_page(@current_page, selector).native.send_keys(:return)
  end
  sleep(0.5)
end

And(/^I change "([^"]*)" to "([^"]*)"$/) do |selection, option|
  step %(I select "#{selection}" to "#{option}")
end

And(/^I check "([^"]*)" checkbox$/) do |locator|
  locator = locator.to_s.downcase.gsub(" ", "_") + "_checkbox"
  checkbox = Finder.element_of_page(@current_page, locator)
  unless checkbox.checked?
    @current_page.click_the(checkbox)
  end
end

And(/^I uncheck "([^"]*)" checkbox$/) do |locator|
  locator = selection.to_s.downcase.gsub(" ", "_") + "_checkbox"
  checkbox = Finder.element_of_page(@current_page, locator)
  if checkbox.checked?
    @current_page.click_the(checkbox)
  end
end


Given(/^I am connected to mysql$/) do
  DB.connect()
  binding.pry
end

And(/^I quick_click "([^"]*)"$/) do |arg|
  BasePage.new.quick_click(arg)
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
  API.create_gig(type, role, date, start_time, end_time, desc, v_desc, location)
end


And(/^It's ([^"]*) is "([^"]*)"$/) do |any, text|
  expect(test_context[:current_row].has_text? text)
end

And(/^I should see ([^"]*) "([^"]*)" for the first "([^"]*)" within "([^"]*)" table$/) do |any, text, arg2, arg3|
  expect((@current_page.find_element(test_context[:current_row_path])).has_text? text)
end

And(/^I should not see ([^"]*) "([^"]*)" for the first "([^"]*)" within "([^"]*)" table$/) do |any, text, arg2, arg3|
  expect((@current_page.find_element(test_context[:current_row_path])).has_no_text? text)
end

Then(/^I go back$/) do
  page.evaluate_script('window.history.back()')
  if page.has_text? @current_page.title
    page.evaluate_script('window.history.back()')
  end
  page.driver.browser.navigate.refresh
end

Given(/^([^"]*) accept gig with ([^"]*) "([^"]*)"$/) do |any, any2, query|
  API.accept_gig(query)
end

Given(/^I resize window to "([^"]*)"$/) do |arg|
  x = arg.to_s.split("x")[0]
  y = arg.to_s.split("x")[1]
  Capybara.current_session.driver.browser.manage.window.resize_to(x, y)
end

And(/^I upload "([^"]*)" image as "([^"]*)"$/) do |image, where|
  selector = where.to_s.downcase.gsub(" ", "_") + "_image"
  locator = Finder.locator(@current_page, selector)
  @current_page.upload_image(locator, image)
  sleep(3)
  file_path = File.expand_path("../../support/screenshots", __FILE__)+'/upload_roleimage_test.png'
  page.driver.browser.save_screenshot file_path
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


And(/^I should see (\d+) ([^"]*) with ([^"]*) "([^"]*)"$/) do |number, more, any2, text|
  nodes_path = test_context[:current_search_results].path + "/child::*"
  node = all(:xpath, "#{nodes_path}").each { |node| node.has_content?(text) }
  if more.to_s.include? "more"
    expect(node.count == (number.to_i + test_context[:current_count_for_search_results].to_i))
  else
    expect(node.count == number.to_i)
  end

end

Given(/^DB get number of "([^"]*)" gigs$/) do |arg|
  pending
end

And(/^I count ([^"]*) with ([^"]*) "([^"]*)"$/) do |any1, any2, text|
  unless test_context[:current_search_results] == "null"
    nodes_path = test_context[:current_search_results].path + "/child::*"
    nodes = all(:xpath, "#{nodes_path}").each { |node| node.has_content?(text) }
    test_context[:current_count_for_search_results] = nodes.count
  else
    test_context[:current_count_for_search_results] = 0
  end
end

And(/^I should see the ([^"]*)$/) do |element|
  selector = element.to_s.downcase.gsub(" ", "_")
  expect(Finder.element_of_page(@current_page, selector).visible?)
end

And(/^I choose month ([^"]*)$/) do |month|
  Calendar.new(@current_page).define_month(month.to_s.downcase)
end

Then(/^I set dates:$/) do |table|
  Calendar.new(@current_page, table).set_dates
end

Given(/^API creates promocode "([^"]*)"$/) do |arg|
  API.create_promocode(arg)
  @test_context[:promocode] = arg
end

And(/^API create following one day GIG with promo:$/) do |table|
  role = table.rows_hash[:role]
  if role == "Bardienst"
    role = 3
  elsif role == "Bediening"
    role = 6
  end
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
  d = Date.parse(date)
  t_s = Time.parse(start_time)
  t_f = Time.parse(end_time)
  start = DateTime.new(d.year, d.month, d.day, t_s.hour, t_s.min, t_s.sec).strftime("%Y-%m-%d %H:%M:%S").to_s
  if t_s < t_f
    finish = DateTime.new(d.year, d.month, d.day, t_f.hour, t_f.min, t_f.sec).strftime("%Y-%m-%d %H:%M:%S").to_s
  else
    d = Date.parse(date) + 1
    finish = DateTime.new(d.year, d.month, d.day, t_f.hour, t_f.min, t_f.sec).strftime("%Y-%m-%d %H:%M:%S").to_s
  end
  desc = table.rows_hash[:description]
  v_desc = table.rows_hash[:'venue description']
  location = table.rows_hash[:location]
  number_of_workers = table.rows_hash[:'number of workers']
  promocode = table.rows_hash[:promocode]
  API.create_gig_with_promo(role, date, start_time, end_time, start, finish, desc, v_desc, location, number_of_workers, promocode)
end

