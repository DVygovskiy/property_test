require 'site_prism'
require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'pry-nav'
require 'active_support/core_ext/string'
require 'net/http'
require 'net/https'
require_relative '../data_objects/web_data'
require_relative '../../features/page-objects/base_page'


class EMAIL_NEW_HELPER < BasePage


    def sign_in_and_out
      visit "http://gmail.com"
      click_the(".//*[@id='Passwd']")
      send_text(".//*[@id='Passwd']", "Faust521")
      click_the(".//*[@id='signIn']")
      click_the(".//*[contains(@title, 'Google Account')]/span")
      click_the(".//*[@aria-label='Account Information']")
      click_the("//a[contains(text(),'Sign out')]")

    end

end

