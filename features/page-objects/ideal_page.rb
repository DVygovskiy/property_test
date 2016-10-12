require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class IdealPage < BasePage

  def title
    ""
  end

  set_url ""

  selector :ideal_button, ".//*[@id='form']/ul/li[1]/a/img"

  selector :bank, ".//*[@id='issuerComponent']"

  selector :submit_button, ".//*[@type='submit']"

  selector :accepted_button, ".//*[@class='accepted']"

  selector :continue_button, ".//*[contains(text(), 'Continue')]"


end
