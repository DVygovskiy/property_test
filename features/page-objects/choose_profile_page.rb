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

  selector :new_gig_tab, "//a[contains(text(), 'Nieuwe gig')]"

  selector :my_gig_tab, "//a[contains(text(), 'Mijn gigs')]"

  selector :profile_tab, "//a[contains(text(), 'Bedrijfprofiel')]"

  selector :settings_tab, "//a[contains(text(), 'Instellingen')]"

  selector :logout_button, "//a//span[contains(text(), 'Uitloggen')]"

  selector :venue_name, "//*[@class='breadcrumbs']/span"

  selector :date_picker, "//*[@id='datepicker']"

  selector :description_field, ".//*[@placeholder='Een korte omschrijving van de gig']"

  selector :about_venue_field, ".//*[@placeholder='Omschrijving']"

  selector :workers_search_result, "#cards"

  selector :select_button, ".//button[contains(text(),'Select')]"

  selector :payment_system, ".//*[@role='combobox']"

  selector :terms, ".//*[@id='afterpay_terms']"

  selector :finish_button, ".//*[@id='step3']/form/div[2]/input"

end
