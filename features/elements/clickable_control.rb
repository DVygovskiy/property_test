require_relative '../helpers/finder'

class ClickableControl

  def initialize(control, text, current_page)
    if control == 'link'
      @selector = text.to_s.downcase + "_link"
    elsif control == 'button'
      @selector = text.to_s.downcase + "_button"
    else
      @selector = text.to_s.downcase + "_tab"
    end
    @selector = @selector.gsub(" ", "_")
    @page = current_page
  end

  def click
    @page.click_the(Finder.element_of_page(@page, @selector))
    new_window = @page.page.driver.browser.window_handles.last
    @page.page.driver.browser.switch_to.window(new_window)
    sleep(0.5)
  end

end


