require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class ViewVacanciesPage < BasePage

  def title
    "Add new vacancy"
  end

  set_url ""

  selector :decline_worker_button, "//input[@value='Decline worker']"

  selector :user_management_tab, "//span[contains(text(), 'Users management')]"

  selector :workers_tab, "//span[contains(text(), 'Workers')]"

  selector :reviews_tab, "//span[contains(text(), 'Reviews')]"

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

  selector :status, "html/body/div[1]/div/section[2]/div/div/form/div[3]/select"

  selector :update_button, "//input[@value='Update']"

  selector :add_new_vacancy_button, "//a[@href='http://clevergig.stg.thebrain4web.com/admin/vacancies/create']"

end
