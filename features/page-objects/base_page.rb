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
