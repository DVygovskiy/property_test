require_relative 'base_page'

class ConfirmationPage < BasePage

  def title
    "Veilig betalen bij clevergig"
  end

  set_url "#{Global.settings.base_url}/events/confirmation"

  selector :new_gig_tab, "//a[contains(text(), 'Nieuwe gig')]"

  selector :my_gig_tab, "//a[contains(text(), 'Mijn gigs')]"

  selector :profile_tab, "//a[contains(text(), 'Bedrijfprofiel')]"

  selector :settings_tab, "//a[contains(text(), 'Instellingen')]"

  selector :logout_button, "//a//span[contains(text(), 'Uitloggen')]"

  selector :venue_name, "//*[@class='breadcrumbs']/span"

  selector :promo_code_field, ".//*[@name='promocode']"

  selector :use_promo_button, ".//*[@value='Toepassen']"

  selector :payment_system, ".//*[@role='combobox']"

  selector :terms_checkbox, ".//*[@id='afterpay_terms']"

  selector :finish_button, "//input[contains(@value, 'Afronden')]"

end
