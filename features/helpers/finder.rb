require_relative '../page-objects/base_page'

class Finder < BasePage

  def self.element_of_page(page, text)
    web_element = page.find_element(page.send(text))
    return web_element
  end


  def self.locator(page, text)
    page.send(text)
  end

  def self.element(text)
    @path = "#{File.expand_path("../../", __FILE__)}/page-objects/*.rb"
    Dir[@path].each do |file|
      pn = Pathname.new(file)
      file_name = pn.basename.to_s.gsub(".rb", "")
      class_id = file_name.classify.constantize
      if class_id.instance_methods(false).grep(text.to_sym).any?
        @current_page = class_id.new
        webelement = @current_page.find_element(@current_page.send(text))
        return webelement
      end
    end
  end

  def self.page_class(text)
    @path = "#{File.expand_path("../../", __FILE__)}/page-objects/*.rb"
    Dir[@path].each { |file|
      pn = Pathname.new(file)
      file_name = pn.basename.to_s.gsub(".rb", "")
      if file_name.include? text.to_s.downcase.gsub(" ", "_")
        class_id = file_name.classify.constantize
        return class_id.new
      end
    }
  end

  def self.class_method(text)
    @path = "#{File.expand_path("../../", __FILE__)}/page-objects/*.rb"
    Dir[@path].each do |file|
      pn = Pathname.new(file)
      file_name = pn.basename.to_s.gsub(".rb", "")
      class_id = file_name.classify.constantize
      if class_id.instance_methods(false).grep(text.to_sym).any?
        @current_page.send(text)
      end
    end
  end



end