require_relative 'base_page'

class ManageEnvironmentPage < BasePage

  def title
    "Environment"
  end

  set_url ""

  selector :manage_isolated_environment, "//a[contains(@href, 'environment')]"

  selector :description_field, ".//*[@name='description']"

  selector :create_button, "//button[text()='Create']"

  selector :customers_tab, "//span[contains(text(), 'Customers')]"

  selector :enable_environment_checkbox, "//input[@name='enabled'][@type='checkbox']"

  selector :payment_needed_checkbox, "//input[@name='payment_enabled'][@type='checkbox']"

  selector :add_role_button, "//button[text()='Add new role']"

  selector :role_title_field, "//input[@placeholder='Role name']"

  selector :role_logo_image, "//input[contains(@name, 'files')]"

  selector :regular_price_field, "//input[@placeholder='Regular price']"

  selector :urgent_price_field, "//input[@placeholder='Urgent price']"

  selector :add_new_worker, "//span[@class='selection']"

  selector :update_button, "//button[text() = 'Update']"

  selector :menu_button, "//a[@class='dropdown-toggle']"

  selector :log_out_button, "//a[@class='dropdown-toggle']"

end
