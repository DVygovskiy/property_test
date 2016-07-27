require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism/page'
require 'site_prism'

require_relative '../data_objects/web_data'

class BasePage < SitePrism::Page

  set_url ""


  def find_element(locator, text = nil)
    begin
        page.has_xpath?(locator)
        find(:xpath, locator)
    rescue
        page.has_css?(locator)
        find(:css, locator)
    end
  end

  def click_the(element)
    if element.kind_of? String
      element = find_element(element)
    end
    begin
      element.click
    rescue
      page.driver.browser.execute_script("$(arguments[0]).click();", element.native)
    end
  end

  def send_text(locator, text)
    click_the(locator)
    find_element(locator).set text
  end

  def check_element_attr(element, query)
    i = false
    attr = Hash.new(:text => element.text,
                    :value => element.value,
                    :href => element[:href],
                    :title => element[:title]
    )
    attr.each_key do |key|
       i = true unless attr[:key] != query
    end
    return i
  end


  def find_from_table(table, text)
      table_object = find_element(table)
      rows_path  = table_object.path + "/child::*"
      node = all(:xpath, "#{rows_path}").detect { |node| node.has_content?(text) }
      return node
  end

  def make_action_in_table(row, action)
    row.all('td').each do |td|
      if !td.all('a').empty?
        td.all('a').each do |a|
          a.click unless check_element_attr(a, action)
        end
      elsif !td.all('div').empty?
        td.all('div').each do |div|
          div.click unless check_element_attr(div, action)
        end
      else
        td.click unless check_element_attr(td, action)
      end
    end
  end

  def quick_click(text)
    if has_xpath?(".//*[contains(text(),'#{text}')]")
      self.click_the(find(:xpath, ".//*[contains(text(),'#{text}')]"))
    else
      self.click_the(find(:xpath, ".//*[contains(@value,'#{text}')]"))
    end
  end


end
