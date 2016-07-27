require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class ConfirmationPage < BasePage

  def title
    "Heeft u een kortingscode? Gebruik hem hier"
  end

  set_url "#{::WEB_DATA[:base_url]}/events/confirmation"


  def new_gig_tab
    "//a[contains(text(), 'Nieuwe gig')]"
  end

  def my_gig_tab
    "//a[contains(text(), 'Mijn gigs')]"
  end

  def profile_tab
    "//a[contains(text(), 'Bedrijfprofiel')]"
  end

  def settings_tab
    "//a[contains(text(), 'Instellingen')]"
  end

  def logout_button
    "//a//span[contains(text(), 'Uitloggen')]"
  end

  def venue_name
    "//*[@class='breadcrumbs']/span"
  end

  def promo_code_field
    ".//*[@name='promocode']"
  end

  def use_promo_button
    ".//*[@value='Toepassen']"
  end

  def payment_system
    ".//*[@role='combobox']"
  end

  def terms
    ".//*[@id='afterpay_terms']"
  end

  def finish_button
    ".//*[@id='step3']/form/div[2]/input"
  end

end
