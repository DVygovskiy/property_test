require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require_relative './base_page.rb'

class DashboardPage < BasePage

  def title
    "Waar kunnen we u mee helpen?"
  end

  set_url "#{::WEB_DATA[:base_url]}/dashboard"

  selector :new_gig_tab, "//a[contains(text(), 'Nieuwe gig')]"

  selector :my_gig_tab, "//a[contains(text(), 'Mijn gigs')]"

  selector :profile_tab, "//a[contains(text(), 'Bedrijfprofiel')]"

  selector :settings_tab, "//a[contains(text(), 'Instellingen')]"

  selector :logout_button, "//a//span[contains(text(), 'Uitloggen')]"

  selector :venue_name, "//*[@class='breadcrumbs']/span"

  selector :urgent_bardienst_button, "//div[1]/div[2]/div[1]/div/div[1]/div[1]/a[1]"

  selector :personal_bardienst_button, "//div[1]/div[2]/div[1]/div/div[1]/div[1]/a[2]"

  selector :urgent_bediening_button, "//div[1]/div[2]/div[1]/div/div[1]/div[2]/a[1]"

  selector :personal_bediening_button, "//div[1]/div[2]/div[1]/div/div[1]/div[2]/a[2]"

  selector :proceed_button, "//*[@id='step1']/form/div[4]/input"

end
