# frozen_string_literal: true

# config valid only for current version of Capistrano
lock '~> 3.14'

set :application, 'ft-forms'
set :repo_url, 'https://github.com/umts/ft-forms.git'
set :branch, :master
set :deploy_to, "/srv/#{fetch :application}"
set :log_level, :info

append :linked_files, 'config/database.yml'
append :linked_dirs, '.bundle', 'log', 'node_modules'

set :passenger_restart_with_sudo, true
