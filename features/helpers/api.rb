
require_relative 'requester'

class API
  include HTTParty_with_cookies

  def self.login_app
    uri_login = URI("#{Global.settings.api_url}/auth/login")
    res = Net::HTTP.post_form(uri_login, 'email' => "#{Global.settings.worker_email}", 'password' => "#{Global.settings.worker_password}")
    res.header.each_header { |key, value| puts "#{key} = #{value}" }
    return JSON.parse(res.body)["token"]
  end

  def self.list_of_gigs
    @token = login_app
    uri_gigs_list = URI("#{Global.settings.api_url}/events")
    http = Net::HTTP.new(uri_gigs_list.host, uri_gigs_list.port)
    data = http.get(uri_gigs_list.request_uri, initheader = {'Authorization' => "Bearer #{@token}"})
    return json_gigs = JSON.parse(data.body)["data"]
  end

  def self.id_of_latest_gig(query)
    id = 0
    list_of_gigs.each do |gig|
      gig.each_key do |key|
        if gig[key].to_s == query && gig["id"] > id
          id = gig["id"]
        end
      end
    end
    return id
  end

  def self.accept_gig(query)
    id = id_of_latest_gig(query)
    uri_accept_gig = URI("#{Global.settings.api_url}/events/#{id}/accept")
    req = Net::HTTP::Put.new(uri_accept_gig, initheader = {'Authorization' => "Bearer #{@token}"})
    response = Net::HTTP.new(uri_accept_gig.host, uri_accept_gig.port).start {|http| http.request(req) }
    puts response.code
  end


  def sign_up
    uri = URI("#{Global.settings.api_url}/auth/signup")
    res = Net::HTTP.post_form(uri, 'email' => "#{(0...8).map { (65 + rand(26)).chr }.join}@mail.ru", 'password' => '123456')
    res.header.each_header { |key, value| puts "#{key} = #{value}" }
    token = JSON.parse(res.body)["token"]

    uri_set_me = URI("#{Global.settings.api_url}/users/me")
    req_set = Net::HTTP::Put.new(uri_set_me)
    req_set.initialize_http_header({'Authorization' => "Bearer #{token}"})

    image = File.open("#{File.dirname(__FILE__)}/Family2.png", "r+")
    req_set.body = {:avatar_url => " ",
                    :birthday => "1969-05-31",
                    :city_id => '46',
                    :first_name => 'Me',
                    :gender => 'male',
                    :iban => '12345',
                    :last_name => 'Test',
                    :passport_url => "image",
                    :phone => '0510003344'}.to_json

    resp_set= Net::HTTP.start(uri_set_me.hostname, uri_set_me.port) do |http|
      http.request(req_set)
    end
  end

  def self.delete_latest_gig
    api = API.new
    requester = Requester.new(api)
    token_form = requester.find_value where: requester.get(path: "auth/login")

    login = requester.post(path: "auth/login",
                           body: {:_token => token_form, :email => Global.settings.admin_email, :password => Global.settings.admin_password}.to_json,
                           content_type: "application/json")
    list_of_gigs = requester.get(path: "admin/gigs")
    id_of_last_gig = Nokogiri::HTML(list_of_gigs).xpath("//table/tr/td[1]").min.text
    token_delete = requester.find_value where: requester.get(path: "admin/gigs/#{id_of_last_gig}")
    delete = requester.post(path: "admin/gigs/#{id_of_last_gig}",
                            :body => {:_token => token_delete,
                                      :_method =>"DELETE"},
                            referrer: "admin/gigs/#{id_of_last_gig}", content_type: "application/x-www-form-urlencoded")
  end

  def self.delete_latest_vacancy
    api = API.new
    requester = Requester.new(api)
    token_form = requester.find_value where: requester.get(path: "auth/login")

    login = requester.post(path: "auth/login",
                           body: {:_token => token_form, :email => Global.settings.admin_email, :password => Global.settings.admin_password}.to_json,
                           content_type: "application/json")
    list_of_vacancies = requester.get(path: "admin/vacancies")
    id_of_last_vacancy = Nokogiri::HTML(list_of_vacancies).xpath("//table/tr/td[1]").max.text
    token_delete = requester.find_value where: requester.get(path: "admin/vacancies/#{id_of_last_vacancy}")
    delete = requester.post(path: "admin/vacancies/#{id_of_last_vacancy}",
                            :body => {:_token => token_delete,
                                      :_method =>"DELETE"},
                            referrer: "admin/gigs/#{id_of_last_vacancy}", content_type: "application/x-www-form-urlencoded")
  end

  def self.delete_latest_promo
    api = API.new
    requester = Requester.new(api)
    token_form = requester.find_value where: requester.get(path: "auth/login")

    login = requester.post(path: "auth/login",
                           body: {:_token => token_form, :email => Global.settings.admin_email, :password => Global.settings.admin_password}.to_json,
                           content_type: "application/json")
    list_of_promos = requester.get(path: "admin/promo")
    id_of_last_promo = Nokogiri::HTML(list_of_promos).xpath("//table/tr/td[1]").max.text
    token_delete = requester.find_value where: requester.get(path: "admin/promo/#{id_of_last_promo}")
    delete = requester.post(path: "admin/promo/#{id_of_last_promo}",
                            :body => {:_token => token_delete,
                                      :_method =>"DELETE"},
                            referrer: "admin/promo/#{id_of_last_promo}", content_type: "application/x-www-form-urlencoded")
  end

  def self.create_gig( role, date, start_time, end_time, start, finish, desc, v_desc, location, number_of_workers)
    api = API.new
    requester = Requester.new(api)

    token_form = requester.find_value where: requester.get(path: "auth/login")

    requester.post(path: "auth/login",
                   body: {:_token => token_form, :email => Global.settings.customer_email, :password => Global.settings.customer_password}.to_json,
                   content_type: "application/json")

    #requester.get(path: "events/upcoming", referrer: "dashboard")

    event_start = requester.get(path: "events/start/one-day/#{role}", referrer: "dashboard")

    event_token = requester.find_value where: event_start

    create = requester.post(path: "events/update",
                            body: {:_token => event_token,
                                   :_method => 'put',
                                   :date => date,
                                   :time_start => start_time,
                                   :start => start,
                                   :time_finish => end_time,
                                   :finish => finish,
                                   :venue_description => v_desc,
                                   :description => desc,
                                   :location => location,
                                   :people_needed => number_of_workers},
                            referrer: "events/new", content_type: "application/x-www-form-urlencoded")

    payment_start = requester.get(path: "events/confirmation", referrer: "events/new")

    payment_token = requester.find_value where: event_start

    payment_event = requester.post(path: "events/payment",
                                   body: {:_token => payment_token,
                                          :_method => 'put',
                                          :gateway => 'afterpay',
                                          :afterpay_terms => 'on'},
                                   referrer: "events/new", content_type: "application/x-www-form-urlencoded")
    sleep(1)

  end

  def self.create_gig_with_promo( role, date, start_time, end_time, start, finish, desc, v_desc, location, number_of_workers, promocode)
    binding.pry
    api = API.new
    requester = Requester.new(api)

    token_form = requester.find_value where: requester.get(path: "auth/login")

    requester.post(path: "auth/login",
                   body: {:_token => token_form, :email => Global.settings.customer_email, :password => Global.settings.customer_password}.to_json,
                   content_type: "application/json")

    #requester.get(path: "events/upcoming", referrer: "dashboard")

    event_start = requester.get(path: "events/start/one-day/#{role}", referrer: "dashboard")

    event_update_time = requester.get(path: "events/start/one-day/#{role}", referrer: "dashboard")

    event_token = requester.find_value where: event_start

    update_date = requester.post(path: "events/update-date",
                                 body: {:_token => event_token,
                                                                   :_method => 'put',
                                                                   :start => start,
                                                                   :finish => finish},
                                 referrer: "events/new", content_type: "application/x-www-form-urlencoded")

    update_venue = requester.post(path: "events/update-venue",
                                 body: {:_token => event_token,
                                        :_method => 'put',
                                        :description => v_desc,
                                        :location => location},
                                 referrer: "events/new", content_type: "application/x-www-form-urlencoded")

    create = requester.post(path: "events/update",
                            body: {:_token => event_token,
                                   :_method => 'put',
                                   :description => desc,
                                   :match_type => "1",
                                   :people_needed => number_of_workers},
                            referrer: "events/new", content_type: "application/x-www-form-urlencoded")

    payment_start = requester.get(path: "events/confirmation", referrer: "events/new")

    token_conf1 = requester.find_value where: payment_start

    apply_code = requester.post(path: "events/apply-code",
                                body: {:_token => token_conf1,
                                       :promocode => promocode},
                                referrer: "events/confirmation", content_type: "application/x-www-form-urlencoded")

    event_conf2 = requester.get(path: "events/confirmation", referrer: "dashboard")

    token_conf2 = requester.find_value where: event_conf2

    payment = requester.post(path: "events/payment",
                             body: {:_token => token_conf2,
                                    :_method => 'put' },
                             referrer: "events/confirmation", content_type: "application/x-www-form-urlencoded")
    sleep(1)

  end

  def self.create_multiday_gig(role: , dates: [], desc:, v_desc:, location:, promocode:, type:)
    api = API.new
    requester = Requester.new(api)

    token_form = requester.find_value where: requester.get(path: "auth/login")

    requester.post(path: "auth/login",
                   body: {:_token => token_form, :email => Global.settings.customer_email, :password => Global.settings.customer_password}.to_json,
                   content_type: "application/json")


    event_start = requester.get(path: "events/start/multi-day/#{role}", referrer: "dashboard")

    event_token = requester.find_value where: event_start

    requester.get(path: "events/new", referrer: "dashboard")

    time = requester.post(path: "events/update-draft-timing",
                          body: {"dates":dates, :_token => event_token}.to_json,
                          referrer: "events/new", content_type: "application/json")


    multi = requester.post(path: "events/update-multi",
                           body: {:_token => event_token,
                                  :_method => 'put',
                                  :multiple_people_needed => type,
                                  :venue_description => v_desc,
                                  :description => desc,
                                  :location => location,
                                  :type => "multiple"},
                           referrer: "events/new", content_type: "application/x-www-form-urlencoded")

    event_conf1 = requester.get(path: "events/confirmation", referrer: "dashboard")

    token_conf1 = requester.find_value where: event_start


    apply_code = requester.post(path: "events/apply-code",
                                body: {:_token => token_conf1,
                                       :promocode => promocode},
                                referrer: "events/confirmation", content_type: "application/x-www-form-urlencoded")

    event_conf2 = requester.get(path: "events/confirmation", referrer: "dashboard")

    token_conf2 = requester.find_value where: event_start

    payment = requester.post(path: "events/payment",
                             body: {:_token => token_conf2,
                                    :_method => 'put' },
                             referrer: "events/confirmation", content_type: "application/x-www-form-urlencoded")


  end


  def self.create_promocode(code)
    api = API.new
    @requester = Requester.new(api)
    token_form = @requester.find_value where: @requester.get(path: "auth/login")
    login = @requester.post(path: "auth/login",
                            body: {:_token => token_form, :email => Global.settings.admin_email, :password => Global.settings.admin_password}.to_json,
                            content_type: "application/json")


    promo = @requester.post(path: "admin/promo",
                            :body => {:_token => token_form,
                                      :code => code,
                                      :usage_limit => "100",
                                      :active => "1",
                                      :active => "1",
                                      :type => "2",
                                      :amount => "100",
                                      'users[]' => Global.settings.promo_id,
                                      :description => "desc"},
                            referrer: "events/new", content_type: "application/x-www-form-urlencoded")
  end

  def self.create_vacancy(title, company_id, status, role_id, desc, v_desc, location)
    api = API.new
    @requester = Requester.new(api)
    token_form = @requester.find_value where: @requester.get(path: "auth/login")
    login = @requester.post(path: "auth/login",
                            body: {:_token => token_form, :email => Global.settings.admin_email, :password => Global.settings.admin_password}.to_json,
                            content_type: "application/json")

    vacancy = @requester.post(path: "admin/vacancies",
                              :body => {:_token => token_form,
                                        :title => title,
                                        :company_id => company_id,
                                        :status => status,
                                        :role_id => role_id,
                                        :venue_description => v_desc,
                                        :description => desc,
                                        :location => location},
                              referrer: "promo/create", content_type: "application/x-www-form-urlencoded")
  end


end
