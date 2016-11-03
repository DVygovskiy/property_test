require_relative 'base_page'

class CreateOneDayGigPage < BasePage

  def title
    "Datum van de gig"
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

  selector :proceed_button, "//input[@value='Volgende stap']"

  selector :start_time, ".//*[@id='timepicker1']"

  selector :end_time, ".//*[@id='timepicker2']"

  selector :workers_search_result, "#cards"

  selector :select_button, ".//button[contains(text(),'Select')]"

  selector :payment_system, ".//*[@role='combobox']"

  selector :terms_checkbox, ".//*[@id='afterpay_terms']"

  selector :finish_button, ".//*[@id='step3']/form/div[2]/input"

  selector :first_role_skills_checkbox, "//input[@name='roleSkills[]'][@value=1]"

  selector :second_role_skills_checkbox, "//input[@name='roleSkills[]'][@value=2]"

  selector :number_of_workers_field, ".//*[@id='people-counter']"

  selector :clever_workers_checkbox, "html/body/main/div[1]/div/div[1]/div/form/div[2]/div/div[1]/div[1]/div[1]/label/i"

  selector :own_pool_workers_checkbox, "html/body/main/div[1]/div/div[1]/div/form/div[2]/div/div[1]/div[1]/div[2]/label/i"

end
