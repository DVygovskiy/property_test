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

  def login_button
    './/*[@id=\'login\']/input[2]'
  end

  def email_field
    './/*[@id=\'login\']/span[1]/input'
  end

  def password_field
    './/*[@id=\'login\']/span[2]/input'
  end

  def make_account_button
    './/*[@id=\'login\']/a[2]'
  end

  def facebook_link
    './/*[@id=\'login\']/div/a[1]'
  end

  def linkedin_link
    './/*[@id=\'login\']/div/a[2]'
  end

  def facebook_login
    assert_text("Log into Facebook")
    find_element(self.facebook_link).click
    fill_in('email', :with => "dante521@bigmir.net")
    fill_in('pass', :with => "brn521")
    find('#loginbutton').click
  end

  def linkedin_login
    assert_text("Sign in to LinkedIn and allow access:")
    find_element(self.linkedin_link).click
    fill_in('Email', :with => "daniel.vygovskiy@gmail.com")
    fill_in('Password', :with => "Faust521")
    find_button('Allow access').click
  end

end
