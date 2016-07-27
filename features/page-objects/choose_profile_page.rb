require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class ChooseProfilePage < BasePage

  def title
    "Kies hier uw voorkeurskandidaat"
  end

  set_url "#{::WEB_DATA[:base_url]}/events/select-worker"

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

  def date_picker
    "//*[@id='datepicker']"
  end

  def description_field
    ".//*[@placeholder='Een korte omschrijving van de gig']"
  end

  def about_venue_field
    ".//*[@placeholder='Omschrijving']"
  end

  def workers_search_result
    "#cards"
  end

  def select_button
    ".//button[contains(text(),'Select')]"
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
