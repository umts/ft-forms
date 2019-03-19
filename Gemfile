# frozen_string_literal: true

source 'https://rubygems.org'

gem 'bootstrap', '~> 4.2.1'
gem 'coffee-rails'
gem 'factory_bot_rails'
gem 'friendly_id', '~> 5.1.0'
gem 'haml'
gem 'haml-rails'
gem 'haml_lint', require: false
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'mysql2'
gem 'puma'
gem 'rails', '~> 5.1'
gem 'redcarpet'
gem 'sass-rails'
gem 'snappconfig'
gem 'uglifier'

group :production do
  gem 'exception_notification'
end

group :development do
  gem 'capistrano', '3.8.1', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-yarn', require: false
  gem 'listen'
  gem 'rb-readline', require: false
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'codeclimate-test-reporter', '~> 1.0'
  gem 'mocha'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-html-matchers'
  gem 'rspec-rails'
  gem 'rubocop'
  gem 'simplecov'
  gem 'spring'
  gem 'timecop'
  gem 'umts-custom-cops'
  gem 'umts-custom-matchers'
end

group :test do
  gem 'capybara'
  gem 'chromedriver-helper'
  gem 'rack_session_access'
  gem 'selenium-webdriver'
end
