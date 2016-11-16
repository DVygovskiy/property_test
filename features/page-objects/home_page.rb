require_relative 'base_page'

class HomePage < BasePage

  def title
    "Wil je bijverdienen in de horeca? Werken op jouw voorwaarden?"
  end

  set_url "#{Global.settings.base_url}"

  selector :register_button, '*//div[1]/div/div[2]/section[1]/div/div[1]/div/div/div[1]/div[2]/a[1]'

  selector :sign_up_button, "//header//a[contains(text(), 'Inloggen')]"

  selector :email_field, "//input[@name='email']"

  selector :password_field, "//input[@name='password']"

  selector :create_account_button, "//button[@type='submit']"

  selector :agree_terms_checkbox, "//input[@type='checkbox']"

  selector :complete_profile_button, "html/body/main/div[1]/div/div[1]/div/div[2]/div[2]/a[1]"

  selector :skip_button, "html/body/main/div[1]/div/div[1]/div/div[2]/div[2]/a[2]"

end
