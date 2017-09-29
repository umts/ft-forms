# config valid only for current version of Capistrano
lock '3.8.1'

set :application, 'ft-forms'
set :repo_url, 'https://github.com/umts/ft-forms.git'
set :branch, :master
set :deploy_to, "/srv/#{fetch :application}"
set :log_level, :info
set :keep_releases, 5

set :linked_files, fetch(:linked_files, []).push( 'config/database.yml')
set :linked_dirs, fetch(:linked_dirs, []).push( 'log')
