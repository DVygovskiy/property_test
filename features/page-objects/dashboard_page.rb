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


  def new_gig_tab
    "//a[contains(text(), 'Nieuwe gig')]"
  end

  def my_gig_tab
    "//a[contains(text(), 'Mijn gigs')]"
  end

  def profile_tab
    "//a[contains(text(), 'Bedrijfprofiel')]"
  end

  def settings_tab
    "//a[contains(text(), 'Instellingen')]"
  end

  def logout_button
    "//a//span[contains(text(), 'Uitloggen')]"
  end

  def venue_name
    "//*[@class='breadcrumbs']/span"
  end

  def urgent_bardienst_button
    "//div[1]/div[2]/div[1]/div/div[1]/div[1]/a[1]"
  end

  def personal_bardienst_button
    "//div[1]/div[2]/div[1]/div/div[1]/div[1]/a[2]"
  end

  def urgent_bediening_button
    "//div[1]/div[2]/div[1]/div/div[1]/div[2]/a[1]"
  end

  def personal_bediening_button
    "//div[1]/div[2]/div[1]/div/div[1]/div[2]/a[2]"
  end

  def proceed_button
    "//*[@id='step1']/form/div[4]/input"
  end



end
