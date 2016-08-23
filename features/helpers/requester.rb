require 'pathname'
require 'pry-nav'
require 'active_support/core_ext/string'
require 'http.rb'
require 'net/http'
require 'mechanize'
require 'httparty'
require 'httparty_with_cookies'
require 'nokogiri'
require 'bundler/setup'
require_relative '../data_objects/web_data'

class Requester
  def initialize(api)
    @api = api
    @current_cookie = ''
  end

  def get(path:, referrer: '')
    result = @api.get(URI("#{WEB_DATA[:api_url]}/#{path}"),
                      :headers => set_header(referrer: referrer),
                      follow_redirects: true)
    set_cookie
    result
  end

  def post(path:, body: {}, content_type: '', referrer: '')
    result = @api.post(
        URI("#{WEB_DATA[:api_url]}/#{path}"),
        :body => body,
        :headers => set_header(content_type: content_type, referrer: referrer),
        follow_redirects: true
    )
    set_cookie
    result
  end


  def put(path:, body: {}, content_type: '', referrer: '')

    result = @api.post(
        URI("#{WEB_DATA[:api_url]}/#{path}"),
        :body => body,
        :headers => set_header(content_type: content_type, referrer: referrer),
        follow_redirects: true
    )
    set_cookie
    result
    id = id_of_latest_gig(query)
    uri = URI("#{WEB_DATA[:api_url]}/path")
    req = Net::HTTP::Put.new(uri_accept_gig, initheader = {'Authorization' => "Bearer #{@token}"})
    response = Net::HTTP.new(uri_accept_gig.host, uri_accept_gig.port).start {|http| http.request(req) }
    puts response.code
  end

  def find_value(where:, value: '_token')
    Nokogiri::HTML(where).xpath("//input[@name='#{value}']").attr('value').value
  end

  private

  def set_cookie
    @current_cookie = @api.cookies.map { |key, value| "#{key}=#{value}" }.join("; ")
  end

  def set_header(referrer: '', content_type: '')
    header = {'Accept' => 'text/html, application/xhtml+xml, */*'}
    header.merge! 'Cookie' => @current_cookie                   if @current_cookie.present?
    header.merge! 'Content-Type' => content_type                if content_type.present?
    header.merge! 'Referer' => "#{WEB_DATA[:api_url]}/#{referrer}" if referrer.present?
    header
  end
end