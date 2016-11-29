require_relative '../page-objects/base_page'

class Email < BasePage

  def title
    ""
  end

  set_url ""

  selector :emails_table, ".//*[@class='b-datalist__body']"

  def sing_in_gmail(adress)
    if @page.has_xpath?(".//*[@id='Passwd']")
      @page.find(:xpath, ".//*[@id='Passwd']").set Global.settings.customer_email_password
      @page.find(:xpath, ".//*[@id='signIn']").click
    elsif @page.has_xpath?(".//*[@id='Email']")
      @page.find(:xpath, ".//*[@id='Email']").set "#{account}@gmail.com"
      @page.find(:xpath, ".//*[@id='next']").click
      @page.find(:xpath, ".//*[@id='Passwd']").set Global.settings.customer_email_password
      @page.find(:xpath, ".//*[@id='signIn']").click
    else
      return
    end
  end

  def sign_in_mailru(account)
    unless has_xpath?(".//*[text()='#{Global.settings.customer_email}']")
      find(:xpath, ".//*[@id='mailbox__login']").set account
      find(:xpath, ".//*[@id='mailbox__password']").set Global.settings.customer_email_password
      find(:xpath, ".//*[@id='mailbox__auth__button']").click
    else
      find(:xpath, ".//*[@id='js-mailbox-enter']/span")
      find(:xpath, ".//*[@id='js-mailbox-enter']/span").click
    end
    sleep(1)
  end

  def delete_all_mailru
    find(:xpath, ".//*[@id='b-toolbar__right']/div[2]/div/div[2]/div[1]/div/div[1]/div[1]/div[1]").click
    find(:xpath, ".//*[@id='b-toolbar__right']/div[2]/div/div[2]/div[2]/div/div[1]/span").click
  end

  def sign_out(email)
    if email == "mail.ru"
      find(:xpath, ".//*[@id='PH_logoutLink']").click
    else
      Capybara.using_wait_time 5 do
        find(:xpath, ".//*[contains(@title, 'Google Account')]/span").click
        find(:xpath, ".//*[@aria-label='Account Information']//a[contains(text(), 'Sign out')]").click
      end
    end
  end

  def sign_in(adress)
    email = adress.split("@")[1]
    account = adress.split("@")[0]
    visit "http://#{email}"
    if email == "mail.ru"
      sign_in_mailru(account)
    elsif email == "gmail.com"
      sign_in_gmail(account)
    end

  end
end




#delete in mailru
#find(".ico.ico_toolbar.ico_toolbar_remove").click

#delete in gmail
#find(:xpath, ".//div[@data-tooltip = 'Delete']").click
