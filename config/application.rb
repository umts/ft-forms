require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module FtForms
  class Application < Rails::Application
    config.encoding = 'utf-8'
    config.time_zone = 'Eastern Time (US & Canada)'
    config.autoload_paths << Rails.root.join('lib')
    config.autoload_paths << Rails.root.join('vendor/lib')
    config.filter_parameters += [:password, :secret, :spire, :github]

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0
  end
end
