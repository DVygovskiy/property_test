require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class LoginPage < BasePage

  def title
    "Inloggen"
  end

  set_url  "#{WEB_DATA[:base_url]}/auth/login"

  selector :login_button, './/*[@id=\'login\']/input[2]'

  selector :email_field, './/*[@id=\'login\']/span[1]/input'

  selector :password_field, './/*[@id=\'login\']/span[2]/input'

  selector :make_account_button, './/*[@id=\'login\']/a[2]'

  selector :facebook_link , './/*[@id=\'login\']/div/a[1]'

  selector :linkedin_link, './/*[@id=\'login\']/div/a[2]'

end
