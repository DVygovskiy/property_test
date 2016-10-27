require 'pry-nav'
require 'active_support/core_ext/string'
require 'net/http'
require 'net/https'
require_relative '../data_objects/web_data'
require 'http.rb'
require 'mechanize'
require 'httparty'
require 'httparty_with_cookies'
require 'nokogiri'
require 'bundler/setup'
require_relative 'requester'

class API
  include HTTParty_with_cookies

  def self.login_app
    uri_login = URI("#{WEB_DATA[:api_url]}/auth/login")
    res = Net::HTTP.post_form(uri_login, 'email' => "tkach.danilo@mail.ru", 'password' => 'qwerty')
    res.header.each_header { |key, value| puts "#{key} = #{value}" }
    return JSON.parse(res.body)["token"]
  end

  def self.list_of_gigs
    @token = login_app
    uri_gigs_list = URI("#{WEB_DATA[:api_url]}/events")
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
    uri_accept_gig = URI("#{WEB_DATA[:api_url]}/events/#{id}/accept")
    req = Net::HTTP::Put.new(uri_accept_gig, initheader = {'Authorization' => "Bearer #{@token}"})
    response = Net::HTTP.new(uri_accept_gig.host, uri_accept_gig.port).start {|http| http.request(req) }
    puts response.code
  end


  def sign_up
    uri = URI('https://www.clevergig.nl/api/v1/auth/signup')
    res = Net::HTTP.post_form(uri, 'email' => "#{(0...8).map { (65 + rand(26)).chr }.join}@mail.ru", 'password' => '123456')
    res.header.each_header { |key, value| puts "#{key} = #{value}" }
    token = JSON.parse(res.body)["token"]

    uri_set_me = URI('https://www.clevergig.nl/api/v1/users/me')
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
    binding.pry
  end

  def self.create_gig(type, role, date, start_time, end_time, desc, v_desc, location)
    api = API.new
    api.get "#{WEB_DATA[:base_url]}/auth/login"
    cookies = api.cookies.map { |key, value| "#{key}=#{value}" }.join("; ")
    token_form = Nokogiri::HTML(api.get "#{WEB_DATA[:base_url]}/auth/login").xpath('//input[@name="_token"]').attr('value').value


    api_res = api.post(
        URI("#{WEB_DATA[:base_url]}/auth/login"),
        :body => {:_token => token_form, :email => 'clevergig@mail.ru', :password => '123456'}.to_json,
        :headers => {'Cookie' => cookies, 'Content-Type' => "application/json", 'Accept' => 'text/html, application/xhtml+xml, */*'},
        follow_redirects: true
    )
    cookies = api.cookies.map { |key, value| "#{key}=#{value}" }.join("; ")

    events = api.get(URI("#{WEB_DATA[:base_url]}/events/upcoming"),
                     :headers => {'Cookie' => cookies,
                                  'Accept' => 'text/html, application/xhtml+xml, */*',
                                  'Referer' => "#{WEB_DATA[:base_url]}/dashboard"},
                     follow_redirects: true)
    cookies = api.cookies.map { |key, value| "#{key}=#{value}" }.join("; ")
    event_start = api.get(URI("#{WEB_DATA[:base_url]}/events/start/#{type}/#{role}"),
                          :headers => {'Cookie' => cookies,
                                       'Accept' => 'text/html, application/xhtml+xml, */*',
                                       'Referer' => "#{WEB_DATA[:base_url]}/dashboard"},
                          follow_redirects: true)
    cookies = api.cookies.map { |key, value| "#{key}=#{value}" }.join("; ")
    event_token = Nokogiri::HTML(event_start).xpath('//input[@name="_token"]').attr('value').value
    create_event = api.post(
        URI("#{WEB_DATA[:base_url]}/events/update"),
        :body => {:_token => event_token,
                  :_method => 'put',
                  :date => date,
                  :time_start => start_time,
                  :time_finish => end_time,
                  :description => desc,
                  :venue_description => v_desc,
                  :location => location},
        :headers => {'Referer' => "#{WEB_DATA[:base_url]}/events/new", 'Cookie' => cookies, 'Content-Type' => "application/x-www-form-urlencoded", 'Accept' => 'text/html, application/xhtml+xml, */*'},
        follow_redirects: true
    )
    cookies = api.cookies.map { |key, value| "#{key}=#{value}" }.join("; ")
    payment_event = HTTParty.post(
        URI("#{WEB_DATA[:base_url]}/events/payment"),
        :body => {:_token => event_token,
                  :_method => 'put',
                  :gateway => 'afterpay',
                  :afterpay_terms => 'on'},
        :headers => {'Referer' => "#{WEB_DATA[:base_url]}/events/confirmation", 'Cookie' => cookies, 'Content-Type' => "application/x-www-form-urlencoded", 'Accept' => 'text/html, application/xhtml+xml, */*'},
        follow_redirects: true,
        timeout: 10
    )
  end

  def self.create_gig_with_promo( role, date, start_time, end_time, start, finish, desc, v_desc, location, number_of_workers, promocode)
    api = API.new
    requester = Requester.new(api)

    token_form = requester.find_value where: requester.get(path: "auth/login")

    requester.post(path: "auth/login",
                   body: {:_token => token_form, :email => 'clevergig@mail.ru', :password => '123456'}.to_json,
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

  def self.create_promocode(code)
    api = API.new
    @requester = Requester.new(api)
    token_form = @requester.find_value where: @requester.get(path: "auth/login")
    login = @requester.post(path: "auth/login",
                            body: {:_token => token_form, :email => 'admin@clevergig.nl', :password => 'admin'}.to_json,
                            content_type: "application/json")


    promo = @requester.post(path: "admin/promo",
                            :body => {:_token => token_form,
                                      :code => code,
                                      :usage_limit => "100",
                                      :active => "1",
                                      :type => "2",
                                      :amount => "100",
                                      'users[]' => "64",
                                      :description => ""},
                            referrer: "events/new", content_type: "application/x-www-form-urlencoded")
  end

end
