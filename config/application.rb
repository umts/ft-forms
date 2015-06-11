require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module FtForms
  class Application < Rails::Application
    config.generators do |g|
      g.assets          false
      g.helpers         false
      g.stylesheets     false
      g.template_engine :haml
      g.test_framework  :rspec
    end
  end
end
