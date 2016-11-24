require_relative 'base_page'

class CreateVacancyPage < BasePage

  def title
    "Create new vacancy"
  end

  set_url ""

  selector :title_field, ".//*[@id='title']"

  selector :venue, ".//span[text()='Start typing to select a venue']"

  selector :status, ".//select/*[text()='Select status']"

  selector :role, "//span[contains(@id, 'role')]"

  selector :role_skills_first_checkbox, "//input[@name='roleSkills[]'][1]"

  selector :promo_tab, "//span[contains(text(), 'Promo')]"

  selector :referral_promo_tab, "//span[contains(text(), 'Referral promo')]"

  selector :gigs_tab, "//span[contains(text(), 'Gigs')]"

  selector :roles_tab, "//span[contains(text(), 'Roles')]"

  selector :payments_tab, "//span[contains(text(), 'Payments')]"

  selector :payments_from_customers_tab, "//span[contains(text(), 'Payments from customers')]"

  selector :payouts_to_workers_tab, "//span[contains(text(), 'Payouts to workers')]"

  selector :pending_payouts_tab, "//span[contains(text(), 'Pending payouts')]"

  selector :settings_tab, "//span[contains(text(), 'Settings')]"

  selector :gigs_under_settings_section_tab, "html/body/div[1]/aside/section/ul/li[8]/ul/li[2]/a/span"

  selector :promo_under_settings_section_tab, "html/body/div[1]/aside/section/ul/li[8]/ul/li[3]/a/span"

  selector :vacancies_table, "//table/tbody"

  selector :update_button, "//input[@value='Update']"

  selector :add_new_vacancy_button, "//a[@href='#{Global.settings.base_url}/admin/vacancies/create']"

  selector :skills, "//input[contains(@placeholder, 'andere')]"

  selector :clothing, "//input[contains(@placeholder, 'kleding')]"

  selector :location, ".//input[@name='location']"

  selector :description_field, ".//textarea[@name='description']"

  selector :venue_description_field, ".//textarea[@name='venue_description']"

  selector :create_button, "//input[@value='Create']"


end
