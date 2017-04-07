set :puma_tag, "Counterfind Production"
set :puma_threads, [0, 4]
set :puma_workers, 8

set :branch, :production

server "dev.counterfind.com",
  user: "deployer",
  roles: [:app, :web, :db, :sidekiq],
  ssh_options: {
    forward_agent: true
  }
