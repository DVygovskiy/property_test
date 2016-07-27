require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class GigDetailsPage < BasePage

  def title
    "Datum van de gig"
  end

  set_url "#{::WEB_DATA[:base_url]}/events/new"


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

  def required_skills_field
    ".//*[@placeholder='Welke vaardigheden zijn nodig']"
  end

  def required_clothing_field
    ".//*[@placeholder='Welke kleding richtlijnen zijn er']"
  end

  def proceed_button
    ".//*[@id='step1']/form/div[4]/input"
  end

  def start_time
    ".//*[@id='timepicker1']"
  end

  def end_time
    ".//*[@id='timepicker2']"
  end

  def choose_date(datetime)
    find_element(date_picker).set datetime
  end

  def set_duration(s_time, e_time)
    page.driver.browser.execute_script("$(arguments[0]).val('#{s_time}');", find_element(start_time).native)
    page.driver.browser.execute_script("$(arguments[0]).val('#{e_time}');", find_element(end_time).native)
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
