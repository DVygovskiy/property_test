require_relative '../../config/requirements'

And(/^I look for the first "([^"]*)" with "([^"]*)" ([^"]*) within "([^"]*)" table$/) do |any, arg, any2, name_of_table|
  @table = Table.new(@current_page, self, name_of_table)
  @table.first_cell_exists? arg
end

And(/^I look for the "([^"]*)" with "([^"]*)" ([^"]*) within "([^"]*)" table$/) do |any, arg, any2, name_of_table|
  @table = Table.new(@current_page, self, name_of_table)
  @table.cell_exists? arg
end

And(/^I click the "([^"]*)" it$/) do |action|
  @table.make_action_in_table(action)
  sleep(1)
end

Then(/^I should see (search results|table) with "([^\"]*)"$/) do |group, text|
  @table = Table.new(@current_page, self, text)
  @table.table_exists?
end

And(/^I should see ([^"]*) "([^"]*)" for the first "([^"]*)" within "([^"]*)" table$/) do |any, text, arg2, name_of_table|
  @table = Table.new(@current_page, self, name_of_table)
  @table.first_cell_exists?(text)
end

And(/^I should not see ([^"]*) "([^"]*)" for the first "([^"]*)" within "([^"]*)" table$/) do |any, text, arg2, name_of_table|
  @table = Table.new(@current_page, self, name_of_table)
  @table.cell_does_not_exist?(text)
end

And(/^I should see (\d+) ([^"]*) with ([^"]*) "([^"]*)"$/) do |number, more, any2, text|
  @table.compare_number_of_items(number, more, text)
end

And(/^I count ([^"]*) with ([^"]*) "([^"]*)"$/) do |any1, any2, text|
  @table.count_items text
end