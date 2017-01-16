require 'site_prism'

class BasePage < SitePrism::Page

  set_url ""

  def self.selector(element_name, find_selector)
    define_method element_name.to_s do |*args|
      find_selector
    end
  end

  def open
    if self.url != ""
      self.load
    end
    sleep(0.5)
    begin
      if page.driver.browser.window_handles.first != page.driver.browser.window_handles.last
        old_window = page.driver.browser.window_handles.first
        page.driver.browser.switch_to.window(old_window)
        Capybara.current_session.current_window.close
        back = page.driver.browser.window_handles.last
        page.driver.browser.switch_to.window(back)
        sleep(1)
      end
      expect(page).to have_text self.title
    rescue
      if page.driver.browser.window_handles.first != page.driver.browser.window_handles.last
        open
      end
    end
  end

  def find_element(locator)
    if page.has_xpath?(locator)
      find(:xpath, locator)
    elsif page.has_css?(locator)
      find(:css, locator)
    end
  end

  def find_all_elements(locator)
    if page.has_xpath?(locator)
      all(:xpath, locator)
    elsif page.has_css?(locator)
      all(:css, locator)
    end
  end

  def click_the(element)
    if element.kind_of? String
      element = find_element(element)
    end
    element.click
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
end
