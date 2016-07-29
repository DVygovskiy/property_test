require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class EditGigPage < BasePage

  def title
    "Description"
  end

  set_url ""

  def user_management_tab
    "//span[contains(text(), 'Users management')]"
  end

  def user_management_tab
    "//span[contains(text(), 'Users management')]"
  end

  def workers_tab
    "//span[contains(text(), 'Workers')]"
  end

  def reviews_tab
    "//span[contains(text(), 'Reviews')]"
  end

  def promo_tab
    "//span[contains(text(), 'Promo')]"
  end

  def referral_promo_tab
    "//span[contains(text(), 'Referral promo')]"
  end

  def gigs_tab
    "//span[contains(text(), 'Gigs')]"
  end

  def roles_tab
    "//span[contains(text(), 'Roles')]"
  end

  def payments_tab
    "//span[contains(text(), 'Payments')]"
  end

  def payments_from_customers_tab
    "//span[contains(text(), 'Payments from customers')]"
  end

  def payouts_to_workers_tab
    "//span[contains(text(), 'Payouts to workers')]"
  end

  def pending_payouts_tab
    "//span[contains(text(), 'Pending payouts')]"
  end

  def settings_tab
    "//span[contains(text(), 'Settings')]"
  end

  def gigs_under_settings_section_tab
    "html/body/div[1]/aside/section/ul/li[8]/ul/li[2]/a/span"
  end

  def promo_under_settings_section_tab
    "html/body/div[1]/aside/section/ul/li[8]/ul/li[3]/a/span"
  end

  def workers_table
    '*//div[1]/div/section[2]/div[3]/div/div/div[1]/table'
  end

  def gigs_table
    "//table/tbody"
  end

  def status
    "html/body/div[1]/div/section[2]/div/div/form/div[3]/select"
  end

  def update_button
    "//input[@value='Update']"
  end


end
