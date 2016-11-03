require_relative 'base_page'

class DeclineWorkerPage < BasePage

  def title
    "Toegewezen kandidaat afwijzen"
  end

  set_url ""

  selector :confirm_button, "//input[@value='Ja']"

end
