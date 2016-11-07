require_relative '../elements/table'
require_relative '../page-objects/base_page'

class EMAIL_HELPER


  def initialize(page, context, adress)
    @page = page
    @context = context
    @adress = adress
  end

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

    if @page.has_xpath?(".//*[@id='PH_authLink']")
      @page.find(:xpath, ".//*[@id='mailbox__login']").set account
      @page.find(:xpath, ".//*[@id='mailbox__password']").set Global.settings.customer_email_password
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
    emails = find(:xpath, ".//*[@class='b-datalist__body']")
    nodes_path = emails.path + "/child::*"
    node = all(:xpath, "#{nodes_path}").detect { |node| node.has_content?("#{subject}") }
    expect(!node.nil?)
    unless node.nil?
      within(node) do
        find(:xpath, ".//*[@class='b-checkbox__box']").click
      end
    end
    sleep(5)
    if adress == "mail.ru"
      @page.first(:xpath, ".//div[@class = 'b-datalist__item__info']//div[contains(text(), '#{query}')]").click
    else
      @page.first(:xpath, "//*[@role='link']//span/b[contains(text(),'#{query}')]").click
    end
  end

  def check_mailbox(email, text)
    if email == "mail.ru"

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

  def sign_in
    email = @adress.split("@")[1]
    account = @adress.split("@")[0]
    @page.visit "http://#{email}"
    if email == "mail.ru"
      sign_in_mailru(account)
    elsif email == "gmail.com"
      sign_in_gmail(account)
    end
  end

  def check_for_email(subject)
    if @adress.include? "mail.ru"
      emails = @context.find(:xpath, ".//*[@class='b-datalist__body']")
      nodes_path = emails.path + "/child::*"
      node = @context.all(:xpath, "#{nodes_path}").detect { |node| node.has_content?("#{subject}") }
      @context.expect(!node.nil?)
      node
      node.click
    elsif @adress.include? "gmail"
      emails = find(:xpath, "//div[@role='tabpanel']//table/tbody")
      nodes_path = emails.path + "/child::*"
      node = all(:xpath, "#{nodes_path}").detect { |node| node.has_content?("#{subject}") }
      expect(!node.nil?)
      node.click
    end
    sleep(5)
  end
end


#delete in mailru
#find(".ico.ico_toolbar.ico_toolbar_remove").click

#delete in gmail
#find(:xpath, ".//div[@data-tooltip = 'Delete']").click
