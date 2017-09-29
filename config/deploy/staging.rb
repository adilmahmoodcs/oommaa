set :puma_tag, "Counterfind Staging"
set :puma_threads, [0, 4]
set :puma_workers, 2

set :branch, :master

server "staging.counterfind.com",
  user: "deployer",
  roles: [:app, :web, :db, :sidekiq],
  ssh_options: {
    forward_agent: true
  }
