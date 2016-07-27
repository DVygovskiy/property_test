require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class MyGigsPage < BasePage

  def title
    "Mijn gigs"
  end

  set_url "#{::WEB_DATA[:base_url]}/events/upcoming"


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

  def gigs_table
    ".//*[@class='category_group']"
  end


end
