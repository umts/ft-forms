# frozen_string_literal: true

require 'factory_bot'
require 'pathname'
require 'simplecov'
require 'umts_custom_matchers'

SimpleCov.start 'rails' do
  refuse_coverage_drop
end

Pathname(__dir__).join('support').glob('**/*.rb').each { |f| require f }

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
