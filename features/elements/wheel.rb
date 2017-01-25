require_relative '../helpers/finder'

class Wheel
  def initialize(args, page)
    @selector = args.to_s.downcase.gsub(" ", "_") + "_wheel"
    @page = page
  end

  def set_value(value)
    if Finder.element_of_page(@page, @selector).text == value
      @page.click_the(Finder.element_of_page(@page, @selector))
    end
  end

end


