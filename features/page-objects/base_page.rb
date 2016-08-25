require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism/page'
require 'site_prism'
require 'nokogiri'
require_relative '../data_objects/web_data'


class BasePage < SitePrism::Page

  set_url ""

  def self.selector(element_name, find_selector)
    define_method element_name.to_s do |*args|
      find_selector
    end
  end

  def find_element(locator, text = nil)
    begin
        page.has_xpath?(locator)
        find(:xpath, locator)
    rescue
        page.has_css?(locator)
        find(:css, locator)
    end
  end

  def upload_image(locator, image)
    begin
      page.has_xpath?(locator)
      find(:xpath, locator).set("#{File.expand_path("../../", __FILE__)}/images/#{image}")
    rescue
      page.has_css?(locator)
      find(:css, locator).set(File.absolute_path("#{image}"))
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
    attr = {:text => element.text,
                    :value => element.value,
                    :href => element[:href],
                    :title => element[:title]
    }
    attr.each_key do |key|
      i = true unless attr[key] != query
    end
    return i
  end

  def find_in_child(path, atr)
    all(:xpath, "#{path}/child::*").to_a.reverse.each do |node|
      if check_element_attr(node, atr)
        click_the(node)
        return true
      end
    end
    false
  end


  def find_from_table(table, text)
    rows_path = table.path + "/child::*"
    node = all(:xpath, "#{rows_path}").detect { |node| node.has_content?(text) }
    return node
  end

  def find_first_from_table(table, text)
    rows_path = table.path + "/child::*"
    node = all(:xpath, "#{rows_path}").each do |nod|
      if nod.has_content?(text)
        return nod
      end
    end
  end

  def make_action_in_table(row, action)
    nodes_path = row.path + "/child::*"
    all(:xpath, "#{nodes_path}").each do |node|
      path = node.path
      if all(:xpath, "#{path}/child::*").empty?
        if check_element_attr(node, action)
           click_the(node)
        end
      end
      until all(:xpath, "#{path}/child::*").empty?
        if find_in_child(path, action)
          return
        end
        path = path + "/child::*"
      end
    end
    sleep(1)
  end

  def quick_click(text)
    if has_xpath?(".//*[contains(text(),'#{text}')]")
      self.click_the(find(:xpath, ".//*[contains(text(),'#{text}')]"))
    else
      self.click_the(find(:xpath, ".//*[contains(@value,'#{text}')]"))
    end
  end


end
