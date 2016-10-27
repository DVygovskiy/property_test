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

  selector :menu_tab, "//a[contains(., 'Mijn profiel')]"

  selector :new_gig_tab, "//a[contains(text(), 'Nieuwe gig')]"

  selector :my_gigs_tab, "//a[contains(text(), 'Mijn gigs')]"

  selector :profile_tab, "html/body/header/div/nav/ul/li[4]/ul/li[1]/a"

  selector :settings_tab, "//a[contains(text(), 'Instellingen')]"

  selector :logout_button, "//a[contains(text(), 'Logout')]"

  selector :venue_name, "//*[@class='breadcrumbs']/span"

  selector :one_day_bardienst_button, "//a[@href='http://clevergig.stg.thebrain4web.com/events/start/one-day/3']"

  selector :multi_day_bardienst_button, "//a[@href='http://clevergig.stg.thebrain4web.com/events/start/multi-day/3']"

  selector :one_day_bediening_button, "//a[@href='http://clevergig.stg.thebrain4web.com/events/start/one-day/6']"

  selector :multi_day_bediening_button, "//a[@href='http://clevergig.stg.thebrain4web.com/events/start/one-day/6']"

  selector :proceed_button, "//*[@id='step1']/form/div[4]/input"

end
