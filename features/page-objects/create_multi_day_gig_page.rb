require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class CreateMultiDayGigPage < BasePage

  def title
    "Choose x days in a row or discrete days"
  end

  set_url "#{::WEB_DATA[:base_url]}/events/new"

  selector :new_gig_tab, "//a[contains(text(), 'Nieuwe gig')]"

  selector :my_gig_tab, "//a[contains(text(), 'Mijn gigs')]"

  selector :profile_tab, "//a[contains(text(), 'Bedrijfprofiel')]"

  selector :settings_tab, "//a[contains(text(), 'Instellingen')]"

  selector :logout_button, "//a//span[contains(text(), 'Uitloggen')]"

  selector :venue_name, "//*[@class='breadcrumbs']/span"

  selector :date_picker, "//*[@id='datepicker']"

  selector :description_field, ".//*[@placeholder='Een korte omschrijving van de gig']"

  selector :about_venue_field, ".//*[@placeholder='Omschrijving']"

  selector :required_skills, ".//*[@placeholder='Welke andere vaardigheden zijn nodig?']"

  selector :required_clothing, ".//*[@placeholder='Welke kleding richtlijnen zijn er?']"

  selector :proceed_button, ".//*[@id='step1']/div[2]/input"

  selector :start_time, ".//*[@id='timepicker1']"

  selector :end_time, ".//*[@id='timepicker2']"

  selector :workers_search_result, "#cards"

  selector :select_button, ".//button[contains(text(),'Select')]"

  selector :payment_system, ".//*[@role='combobox']"

  selector :terms_checkbox, ".//*[@id='afterpay_terms']"

  selector :finish_button, "//input[@value='Afronden & betalen']"

  selector :first_role_skills_checkbox, "//input[@name='roleSkills[]'][@value=1]"

  selector :second_role_skills_checkbox, "//input[@name='roleSkills[]'][@value=2]"

  selector :number_of_workers_field, "//input[@name='people_needed']"

  selector :x_days_in_a_row_checkbox, "(//i[@class='pseudo-radio'])[1]"

  selector :discreet_days_checkbox, "(//i[@class='pseudo-radio'])[2]"

  selector :calendar, "//div[@class='calendars']"

  selector :set_dates_button, "//button[text()='Set dates']"

  selector :time_table, "//div[@class='timetable']"

  selector :start_time, "//input[contains(@name, 'time_from')]"

  selector :end_time, "//input[contains(@name, 'time_to')]"

  selector :set_time_button, "//span[text()='Update timing']"



end
