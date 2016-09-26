require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class DeclineWorkerPage < BasePage

  def title
    "Toegewezen kandidaat afwijzen"
  end

  set_url ""

  selector :confirm_button, "//input[@value='Ja']"

end
