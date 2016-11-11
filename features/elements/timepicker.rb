require_relative '../helpers/finder'

class Timepicker
  def initialize(arg, page, context)
    @selector = (arg.to_s.downcase + "_field").gsub(" ", "_")
    @page = page
  end

  def set_time(time)
    Finder.element_of_page(@page, @selector).click
    Finder.element_of_page(@page, @selector).set time
    Finder.element_of_page(@page, @selector).find(:xpath, "./*[text()='#{time}']").click
  end

end
