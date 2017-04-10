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

set :sidekiq_processes, 2
set :sidekiq_options_per_process, [
  "--queue default --queue not_facebook",
  "--tag facebook --concurrency 1 --queue priority,5 --queue posts --queue pages"
]
