# config valid only for current version of Capistrano
lock "3.7.2"

set :application, "counterfind"
set :repo_url, "git@github.com:counterfind/counterfind-rails.git"
set :deploy_to, "/var/www/#{fetch(:application)}_#{fetch(:stage)}"
set :log_level, :debug

# append :linked_files, "config/database.yml", "config/secrets.yml"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

set :rvm_type, :user
set :rvm_ruby_version, '2.4.0'

set :bundle_jobs, 3

set :sidekiq_role, -> { :sidekiq }
set :sidekiq_timeout, 60

set :rollbar_token, "dd1b969fcd9d41bfa12e891423abf01a"
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

namespace :deploy do
  before :publishing, 'puma:config'
  after :finishing, :cleanup
end
