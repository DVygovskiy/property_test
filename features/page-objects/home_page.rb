require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class HomePage < BasePage

  def title
    "Ervaren horecapersoneel"
  end

  set_url "#{WEB_DATA[:base_url]}"

  selector :register_button, '*//div[1]/div/div[2]/section[1]/div/div[1]/div/div/div[1]/div[2]/a[1]'

  selector :sing_up_button, "//header//a[contains(text(), 'Inloggen')]"

  selector :email_field, "//input[@name='email']"

  selector :password_field, "//input[@name='password']"

  selector :create_account_button, "//button[@type='submit']"

end
