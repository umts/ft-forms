# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'factory_bot_rails'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/rspec'
require 'rack_session_access/capybara'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.before :all do
    FactoryBot.reload
  end
  config.include FactoryBot::Syntax::Methods
  config.include UmtsCustomMatchers
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true
end

def login_as(user)
  page.set_rack_session user_id: user.id
end
