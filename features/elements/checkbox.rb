require_relative '../helpers/finder'

class Checkbox
  def initialize(args, page)
    @selector = args.to_s.downcase.gsub(" ", "_") + "_checkbox"
    @page = page
  end

  def check
    checkbox = Finder.element_of_page(@page, @selector)
    unless checkbox.checked?
      @page.click_the(checkbox)
    end
  end

  def uncheck
    checkbox = Finder.element_of_page(@page, @selector)
    if checkbox.checked?
      @page.click_the(checkbox)
    end
  end

end


