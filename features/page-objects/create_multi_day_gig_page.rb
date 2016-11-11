require_relative 'base_page'

class CreateMultiDayGigPage < BasePage

  def title
    "Meerdere dagen"
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

  selector :required_skills, ".//*[@placeholder='Welke andere vaardigheden zijn nodig?']"

  selector :required_clothing, ".//*[@placeholder='Welke kleding richtlijnen zijn er?']"

  selector :select_button, ".//button[contains(text(),'Select')]"

  selector :payment_system, ".//*[@role='combobox']"

  selector :terms_checkbox, ".//*[@id='afterpay_terms']"

  selector :finish_button, "//input[@value='Afronden & betalen']"

  selector :first_role_skills_checkbox, "//input[@name='roleSkills[]'][@value=1]"

  selector :second_role_skills_checkbox, "//input[@name='roleSkills[]'][@value=2]"

  selector :number_of_workers_field, "//input[@name='people_needed']"

  selector :calendar, "//div[@class='calendars']"

  selector :days, "//table[@class='clndr-table']"

  selector :month_label, "//div[@class='month'][1]"

  selector :month_button, "//div[@class='clndr-control-button rightalign']"

  selector :set_dates_button, "//div[@class='timetable__footer']/button[text()='Bevestigen']"

  selector :time_table, "//div[@class='timetable']"

  selector :start_time, "//td[@class='timepickers']//label[text()='van']/following-sibling::select"

  selector :end_time, "//td[@class='timepickers']//label[text()='tot']/following-sibling::select"

  selector :set_time_button, "//button/span[text()='Bevestigen']"

  selector :many_workers_checkbox, "//input[@name='multiple_people_needed'][@value=1]/following-sibling::i"

  selector :only_one_worker_checkbox, "//input[@name='multiple_people_needed'][@value=0]/following-sibling::i"

  selector :set_venue_details_button, "//div[@class='timetable__footer right']/button"

  selector :proceed_button, "//form[@action='#{Global.settings.base_url}/events/update-multi']/following-sibling::div/div/button"

end
