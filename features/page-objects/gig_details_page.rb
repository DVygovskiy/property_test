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

  selector :new_gig_tab, "//a[contains(text(), 'Nieuwe gig')]"

  selector :my_gig_tab, "//a[contains(text(), 'Mijn gigs')]"

  selector :profile_tab, "//a[contains(text(), 'Bedrijfprofiel')]"

  selector :settings_tab, "//a[contains(text(), 'Instellingen')]"

  selector :logout_button, "//a//span[contains(text(), 'Uitloggen')]"

  selector :venue_name, "//*[@class='breadcrumbs']/span"

  selector :date_picker, "//*[@id='datepicker']"

  selector :description_field, ".//*[@placeholder='Een korte omschrijving van de gig']"

  selector :about_venue_field, ".//*[@placeholder='Omschrijving']"

  selector :required_skills_field, ".//*[@placeholder='Welke andere vaardigheden zijn nodig?']"

  selector :required_clothing_field, ".//*[@placeholder='Welke kleding richtlijnen zijn er?']"

  selector :proceed_button, ".//*[@id='step1']/form/div[4]/input"

  selector :start_time, ".//*[@id='timepicker1']"

  selector :end_time, ".//*[@id='timepicker2']"

  selector :workers_search_result, "#cards"

  selector :select_button, ".//button[contains(text(),'Select')]"

  selector :payment_system, ".//*[@role='combobox']"

  selector :terms_checkbox, ".//*[@id='afterpay_terms']"

  selector :finish_button, ".//*[@id='step3']/form/div[2]/input"

  selector :first_role_skills_checkbox, "//input[@name='roleSkills[]'][@value=1]"

  selector :second_role_skills_checkbox, "//input[@name='roleSkills[]'][@value=2]"

  def choose_date(datetime)
    find_element(date_picker).set datetime
  end

  def set_duration(s_time, e_time)
    page.driver.browser.execute_script("$(arguments[0]).val('#{s_time}');", find_element(start_time).native)
    page.driver.browser.execute_script("$(arguments[0]).val('#{e_time}');", find_element(end_time).native)
  end



end
