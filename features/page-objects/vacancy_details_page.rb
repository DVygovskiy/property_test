require_relative 'base_page'

class VacancyDetailsPage < BasePage

  def title
    "Edit vacancy"
  end

  set_url ""

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



end
