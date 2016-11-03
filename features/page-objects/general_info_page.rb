require_relative 'base_page'

class GeneralInfoPage < BasePage

  def title
    "Venue info"
  end

  set_url "#{Global.settings.base_url}/about"

  selector :new_gig_tab, "//a[contains(text(), 'Nieuwe gig')]"

  selector :my_gig_tab, "//a[contains(text(), 'Mijn gigs')]"

  selector :profile_tab, "//a[contains(text(), 'Bedrijfprofiel')]"

  selector :settings_tab, "//a[contains(text(), 'Instellingen')]"

  selector :logout_button, "//a//span[contains(text(), 'Uitloggen')]"

  selector :company_logo_image, "//input[@class='dz-hidden-input'][1]"

  selector :company_galery_image, "//input[@class='dz-hidden-input'][2]"

  selector :description_field, ".//*[@placeholder='Een korte omschrijving van de gig']"

  selector :about_venue_field, ".//*[@placeholder='Omschrijving']"

  selector :workers_search_result, "#cards"

  selector :select_button, ".//button[contains(text(),'Select')]"

  selector :payment_system, ".//*[@role='combobox']"

  selector :terms, ".//*[@id='afterpay_terms']"

  selector :finish_button, ".//*[@id='step3']/form/div[2]/input"

end
