# frozen_string_literal: true

require 'factory_bot'
require 'simplecov'
require 'umts_custom_matchers'

SimpleCov.start 'rails' do
  refuse_coverage_drop
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.default_formatter = 'doc' if config.files_to_run.one?

  config.example_status_persistence_file_path = 'spec/examples.txt'

  #config.disable_monkey_patching!
  #config.warnings = true

  config.order = :random
  Kernel.srand config.seed

  config.before :all do
    FactoryBot.reload
  end

  config.include FactoryBot::Syntax::Methods
  config.include UmtsCustomMatchers
end

# Sets current user based on acceptable values:
# 1. a symbol name of a user factory trait
# 2. a specific instance of User
# 3. nil
def when_current_user_is(user, options = {})
  current_user =
    case user
    when Symbol then create(:user, user)
    when User, nil then user
    else raise ArgumentError, 'Invalid user type'
    end
  set_current_user(current_user)
end

def set_current_user(user)
  case self.class.metadata[:type]
  when :view
    assign :current_user, user
  when :feature, :system
    page.set_rack_session user_id: user.try(:id)
  when :controller
    session[:user_id] = user.try(:id)
    session[:spire] = user.try(:spire) || build(:user).spire
  end
end
