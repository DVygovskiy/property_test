require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class CompleteProfilePage < BasePage

  def title
    "Profiel aanmaken"
  end

  set_url "http://clevergig.stg.thebrain4web.com/complete-profile"

  selector :menu_tab, "//a[contains(., 'Mijn profiel')]"

  selector :new_gig_tab, "//a[contains(., 'Nieuwe')]"

  selector :my_gigs_tab, "//a[contains(., 'Mijn gigs')]"

  selector :promo_tab, "//a[contains(., 'Promo')]"

  selector :general_info_tab, "//a[contains(., 'Bedrijfsinfo')]"

  selector :security_info_tab, "//a[contains(., 'Instellingen')]"

  selector :reviews_tab, "//a[contains(., 'Reviews')]"

  selector :venue_name_field, "//input[@name='title']"

  selector :description_field, ".//*[@id='text']"

  selector :first_name_field, "//input[@name='first_name']"

  selector :last_name_field, "//input[@name='last_name']"

  selector :phone_number_field, "//input[@name='phone']"

  selector :kvk_field, "//input[@name='kvk']"

  selector :btw_field, "//input[@name='vat']"

  selector :street_field, "//input[@name='street']"

  selector :house_number_field, "//input[@name='housenumber']"

  selector :postcode_field, "//input[@name='zip']"

  selector :submit_button, "//input[@type='submit']"


end
