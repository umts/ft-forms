# frozen_string_literal: true

source 'https://rubygems.org'

gem 'coffee-rails'
gem 'factory_girl_rails'
gem 'friendly_id', '~> 5.1.0'
gem 'haml'
gem 'haml-rails'
gem 'haml_lint'
gem 'mysql2'
gem 'rails', '~> 5.1'
gem 'redcarpet'
gem 'sass-rails'
gem 'snappconfig'
gem 'uglifier'
gem 'draftsman', '~> 0.7.0'

source 'https://rails-assets.org' do
  gem 'rails-assets-moment'
end

group :production do
  gem 'exception_notification'
end

group :development do
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-rails', require: false
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
