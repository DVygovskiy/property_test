require_relative 'base_page'

class CreateOneDayGigPage < BasePage

  def title
    "En de werktijden"
  end

  set_url "#{Global.settings.base_url}/events/new"

  selector :new_gig_tab, "//a[contains(text(), 'Nieuwe gig')]"

  selector :my_gig_tab, "//a[contains(text(), 'Mijn gigs')]"

  selector :profile_tab, "//a[contains(text(), 'Bedrijfprofiel')]"

  selector :settings_tab, "//a[contains(text(), 'Instellingen')]"

  selector :logout_button, "//a//span[contains(text(), 'Uitloggen')]"

  selector :venue_name, "//*[@class='breadcrumbs']/span"

  selector :date_picker, "//*[@id='datepicker']"

  selector :description_field, ".//*[@placeholder='Een korte omschrijving van de gig']"

  selector :about_venue_field, ".//*[@placeholder='Omschrijving']"

  selector :required_skills, ".//input[@placeholder='Welke andere vaardigheden zijn nodig?']"

  selector :required_clothing, ".//input[@placeholder='Welke kleding richtlijnen zijn er?']"

  selector :start_time, "//label[text()='van']/following-sibling::select"

  selector :end_time, "//label[text()='tot']/following-sibling::select"

  selector :select_button, ".//button[contains(text(),'Select')]"

  selector :payment_system, ".//*[@role='combobox']"

  selector :terms_checkbox, ".//*[@id='afterpay_terms']"

  selector :finish_button, ".//*[@id='step3']/form/div[2]/input"

  selector :first_role_skills_checkbox, "//input[@name='roleSkills[]'][@value=1]"

  selector :second_role_skills_checkbox, "//input[@name='roleSkills[]'][@value=2]"

  selector :number_of_workers_field, ".//*[@id='people-counter']"

  selector :clever_workers_checkbox, "//input[@value=1]/following-sibling::i[@class='pseudo-radio']"

  selector :own_pool_workers_checkbox, "//input[@value=2]/following-sibling::i[@class='pseudo-radio']"

  selector :calendar, "//table"

  selector :days, "//table"

  selector :month_label, "//div[@class='month']"

  selector :month_button, "//div[contains(@class, 'clndr-control-button')][2]"

  selector :set_up_dates_button, "//button/span[text()='Bevestigen']"

  selector :set_venue_details_button, "//form[@action='#{Global.settings.base_url}/events/update-venue']/following-sibling::div/button"

  selector :proceed_button, "//form[@action='#{Global.settings.base_url}/events/update']/following-sibling::div/div/button"


end
