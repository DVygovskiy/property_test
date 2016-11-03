
class EMAIL_HELPER


  def initialize(page)
    @page = page
  end

  def sing_in_gmail
    if @page.has_xpath?(".//*[@id='Passwd']")
      @page.find(:xpath, ".//*[@id='Passwd']").set "Faust521"
      @page.find(:xpath, ".//*[@id='signIn']").click
    elsif @page.has_xpath?(".//*[@id='Email']")
      @page.find(:xpath, ".//*[@id='Email']").set "daniel.vygovskiy@gmail.com"
      @page.find(:xpath, ".//*[@id='next']").click
      @page.find(:xpath, ".//*[@id='Passwd']").set "Faust521"
      @page.find(:xpath, ".//*[@id='signIn']").click
    else
      return
    end
  end

  def sign_in_mailru
    if @page.has_xpath?(".//*[@id='PH_authLink']")
      @page.find(:xpath, ".//*[@id='mailbox__login']").set "clevergig"
      @page.find(:xpath, ".//*[@id='mailbox__password']").set "brn521"
      @page.find(:xpath, ".//*[@id='mailbox__auth__button']").click
    else
      @page.find(:xpath, ".//*[@id='js-mailbox-enter']/span")
      @page.find(:xpath, ".//*[@id='js-mailbox-enter']/span").click
    end
    @page.has_xpath?(".//*[@id='b-nav_folders']/div/div[1]/a/span[2]")
  end

  def delete_all_mailru
    @page.find(:xpath, ".//*[@id='b-toolbar__right']/div[2]/div/div[2]/div[1]/div/div[1]/div[1]/div[1]").click
    @page.find(:xpath, ".//*[@id='b-toolbar__right']/div[2]/div/div[2]/div[2]/div/div[1]/span").click
  end


  def find_email(adress, query)
    if adress == "mail.ru"
      @page.first(:xpath, ".//div[@class = 'b-datalist__item__info']//div[contains(text(), '#{query}')]").click
    else
      @page.first(:xpath, "//*[@role='link']//span/b[contains(text(),'#{query}')]").click
    end
  end

  def check_mailbox(email, text)
    @page.visit "http://#{email}"
    if email == "mail.ru"
      sign_in_mailru
    else
=begin
      sing_in_gmail
      rows_path  = table_object.path + "/child::*"
      node = all(:xpath, "#{rows_path}").detect { |node| node.has_content?(text) }
      within(:css, "table > tbody") do
        tr = @page.all(:xpath, "/tr").detect { |tr| tr.has_content?(text) }
        unless tr.nil?
          within(tr) do
            test_context[:current_page].click_the(test_context[:current_page].select_button)
            new_window = page.driver.browser.window_handles.last
            page.driver.browser.switch_to.window(new_window)
          end
        end
      end

      elements = @page.all("table > tbody > tr > td", :text => 'Completed')
      attr = Hash.new
      elements[0].path.split("/").each do |div|
        if div.include? "td"
          attr[:div] = "/#{div}"
        end
      end
      tr_path = elements[0].path.gsub(attr[:div],'')
=end
    end
  end

  def sign_out(email)
    if email == "mail.ru"
      @page.find(:xpath, ".//*[@id='PH_logoutLink']").click
    else
      Capybara.using_wait_time 5 do
      @page.find(:xpath, ".//*[contains(@title, 'Google Account')]/span").click
      @page.find(:xpath, ".//*[@aria-label='Account Information']//a[contains(text(), 'Sign out')]").click
      end
    end
  end
end

#delete in mailru
#find(".ico.ico_toolbar.ico_toolbar_remove").click

#delete in gmail
#find(:xpath, ".//div[@data-tooltip = 'Delete']").click