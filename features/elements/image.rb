require_relative '../helpers/finder'

class Image
  def initialize(args, page, context)
    @selector = args.to_s.downcase.gsub(" ", "_") + "_image"
    @page = page
    @context = context
  end

  def upload(name)
    locator = Finder.locator(@page, @selector)
    begin
      @page.has_xpath?(locator)
      if ENV['docker'] == "true"
        @context.find(:xpath, locator).set("/images/#{name}")
      else
        puts "#{File.expand_path("../../", __FILE__)}/images/#{name}"
        @context.find(:xpath, locator).set("#{File.expand_path("../../", __FILE__)}/images/#{name}")
      end
    rescue
      @page.has_css?(locator)
      @context.find(:css, locator).set("#{File.expand_path("../../", __FILE__)}/images/#{name}")
    end
    sleep(3)
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

end


