# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'rack_session_access/capybara'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.before :all do
    FactoryGirl.reload
  end
  config.include FactoryBot::Syntax::Methods
  config.include UmtsCustomMatchers
  config.include RSpecHtmlMatchers, type: :view
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
  config.before :each, type: :system do
    driven_by :selenium_chrome_headless
  end
end
