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

class API
  include HTTParty_with_cookies
  def self.login(user)
    uri = URI("#{WEB_DATA[:api_url]}/auth/login")
    res = Net::HTTP.post_form(uri, 'email' => "#{(0...8).map { (65 + rand(26)).chr }.join}@mail.ru", 'password' => '123456')
    res.header.each_header { |key, value| puts "#{key} = #{value}" }
    token = JSON.parse(res.body)["token"]

    uri_set_me = URI('https://www.clevergig.nl/api/v1/users/me')
    req_set = Net::HTTP::Put.new(uri_set_me)
    req_set.initialize_http_header({'Authorization' => "Bearer #{token}"})


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

end
