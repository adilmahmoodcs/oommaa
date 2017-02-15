set :puma_tag, "Counterfind Production"
set :puma_threads, [0, 4]
set :puma_workers, 2

server "ec2-54-234-172-199.compute-1.amazonaws.com",
  user: "deployer",
  roles: [:app, :web, :db, :sidekiq],
  ssh_options: {
    forward_agent: true
  }
