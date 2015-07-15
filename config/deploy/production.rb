server 'af-transit-app3.admin.umass.edu',
        roles: %w{app db web},
        user: (Net::SSH::Config.for('af-transit-app3.admin.umass.edu')[:user] || ENV['USER'])
set :bundle_env_variables, { 'NOKOGIRI_USE_SYSTEM_LIBRARIES' => 1 }
set :passenger_environment_variables, { 'PASSENGER_INSTANCE_REGISTRY_DIR' => '/var/run/passenger-instrg/ft-forms' }
