require 'site_prism'

class BasePage < SitePrism::Page

  set_url ""

  def self.selector(element_name, find_selector)
    define_method element_name.to_s do |*args|
      find_selector
    end
  end

  def find_element(locator)
    begin
      page.has_xpath?(locator)
      find(:xpath, locator)
    rescue
      page.has_css?(locator)
      find(:css, locator)
    end
  end

  def find_all_elements(locator)
    begin
      page.has_xpath?(locator)
      all(:xpath, locator)
    rescue
      page.has_css?(locator)
      all(:css, locator)
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


  #Not working. Should be implemented
  def drop_image(locator, image)
    # Generate a fake input selector
    page.execute_script <<-JS
    fakeFileInput = window.$('<input/>').attr(
      {id: 'fakeFileInput', type:'file'}
    ).appendTo('body');
    JS
    file_path = "#{File.expand_path("../../", __FILE__)}/images/#{image}"
    # Attach the file to the fake input selector with Capybara
    attach_file("fakeFileInput", file_path)
    # Add the file to a fileList array
    page.execute_script("var fileList = [fakeFileInput.get(0).files[0]]")
    # Trigger the fake drop event
    page.execute_script <<-JS
    var e = jQuery.Event('drop', { dataTransfer : { files : [fakeFileInput.get(0).files[0]]  } });
    $('.upload_zone').dropzone.listeners[0].events.drop(e);
    JS
    sleep(10)
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
    unless element == nil
      attr = {:text => element.text,
              :value => element.value,
              :href => element[:href],
              :title => element[:title],
              :innerHtml => element['innerHTML']
      }
      attr.each_key do |key|
        i = true unless attr[key].to_s != query
      end
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
    if has_xpath?(".//a[text()='#{text}']")
      self.click_the(find(:xpath, ".//a[text()='#{text}']"))
    elsif has_xpath?(".//a[contains(@value,'#{text}')]")
      self.click_the(find(:xpath, ".//a[contains(@value,'#{text}')]"))
    elsif has_xpath?(".//div[text()='#{text}']")
      self.click_the(find(:xpath, ".//div[text()='#{text}']"))
    elsif has_xpath?(".//div[contains(@value,'#{text}')]")
      self.click_the(find(:xpath, ".//div[contains(@value,'#{text}')]"))
    elsif has_xpath?(".//span[text()='#{text}']")
      self.click_the(find(:xpath, ".//span[text()='#{text}']"))
    elsif has_xpath?(".//span[contains(@value,'#{text}')]")
      self.click_the(find(:xpath, ".//span[contains(@value,'#{text}')]"))
    end
  end
end
