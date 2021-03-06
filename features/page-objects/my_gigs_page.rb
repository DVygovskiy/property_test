require_relative 'base_page'

class MyGigsPage < BasePage

  def title
    "Mijn gigs"
  end

  set_url "#{Global.settings.base_url}/events/upcoming"

  selector :new_gig_tab, "//a[contains(text(), 'Nieuwe gig')]"

  selector :my_gigs_tab, "//a[contains(text(), 'Mijn gigs')]"

  selector :profile_tab, "//a[contains(text(), 'Bedrijfprofiel')]"

  selector :settings_tab, "//a[contains(text(), 'Instellingen')]"

  selector :logout_button, "//a//span[contains(text(), 'Uitloggen')]"

  selector :venue_name, "//*[@class='breadcrumbs']/span"

  selector :gigs_table, "//div[@class='category_group myGigs']"

end
