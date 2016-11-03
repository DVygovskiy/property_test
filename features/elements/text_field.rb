require_relative '../helpers/finder'
require_relative '../helpers/test_data'

class TextField
  def initialize(args, page)
    @selector = (args.to_s.downcase + "_field").gsub(" ", "_")
    @page = page
  end

  def set_text(text)
    if text.to_s.downcase.include? "random"
      text = TestData.generate(text)
    end
    Finder.element_of_page(@page, @selector).set text
    sleep(0.5)
  end

end
