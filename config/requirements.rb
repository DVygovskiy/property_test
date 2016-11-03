require 'bundler/setup'
Bundler.require
require 'active_support'
require 'active_support/core_ext/string'
require 'cucumber'
require 'pathname'
require 'net/http'
require 'nokogiri'
require 'rspec'
require 'mysql'
require 'ffaker'
require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'site_prism'
require 'pry-nav'
require 'net/https'
require 'http.rb'
require 'mechanize'
require 'httparty'
require 'httparty_with_cookies'
require 'global'

Global.configure do |config|
  config.environment = ENV["TEST_SERVER"] || "stg"
  config.config_directory = File.expand_path('.', File.dirname(__FILE__)).to_s
end

Dir['../page-objects/*.rb'].each { |file| require_relative file }
require_relative '../features/helpers/requirement'
require_relative '../features/elements/requirement'

