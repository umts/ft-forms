# frozen_string_literal: true

source 'https://rubygems.org'
ruby IO.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'bootstrap', '~> 4.3'
gem 'coffee-rails'
gem 'friendly_id', '~> 5.1.0'
gem 'haml'
gem 'haml-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'mysql2'
gem 'puma'
gem 'rails', '~> 5.1'
gem 'redcarpet'
gem 'sassc-rails'
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
  gem 'haml_lint', require: false
  gem 'pry-byebug'
  gem 'rubocop'
  gem 'spring'
  gem 'umts-custom-cops'
end

group :test do
  gem 'capybara'
  gem 'codeclimate-test-reporter', '~> 1.0'
  gem 'factory_bot_rails'
  gem 'rack_session_access'
  gem 'rails-controller-testing'
  gem 'rspec-html-matchers'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'timecop'
  gem 'simplecov'
  gem 'umts-custom-matchers'
  gem 'webdrivers'
end
