source "https://rubygems.org"

git_source(:github) do |repo_name|
  "https://github.com/#{repo_name}.git"
end

ruby "2.4.0"

gem "rails", "~> 5.0.1"
gem "pg", "~> 0.18"
gem "puma", "~> 3.0"

gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.2"
gem "jquery-rails", "~> 4.2.2"
gem "turbolinks", "~> 5"
gem "bootstrap", "~> 4.0.0.alpha6"
gem "font-awesome-sass", "~> 4.7.0"
source "https://rails-assets.org" do
  gem "rails-assets-tether", ">= 1.3.3"
end

gem "devise", "~> 4.2.0"
gem "devise-bootstrap-views", github: "hisea/devise-bootstrap-views", branch: "bootstrap4"
gem "koala", "~> 2.4.0"
gem "sidekiq", "~> 4.2.9"
gem "kaminari", "~> 1.0.1"
gem "public_activity", "~> 1.5.0"
gem "ransack", github: "activerecord-hackery/ransack"
gem "embiggen", "~> 1.2.4"
gem "public_suffix", "~> 2.0"
gem "rinku", "~> 2.0.2"

group :development, :test do
  gem "byebug", platform: :mri
  gem "rspec-rails", "~> 3.5"
  gem "factory_girl_rails"
  gem "vcr"
  gem "webmock"
  gem "database_cleaner"
  gem "faker", "~> 1.7.3"
  gem "rails-controller-testing"
  gem "shoulda-matchers", "~> 3.1"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "rack-livereload"
  gem "guard-livereload", "~> 2.5", require: false
  gem "guard-rails", require: false
  gem "rb-fsevent"
  gem "annotate"
  gem "capistrano", "~> 3.7"
  gem "capistrano-rails", "~> 1.2"
  gem "capistrano-rvm"
  gem "capistrano3-puma"
  gem "capistrano-rails-console"
  gem "capistrano-sidekiq", github: "seuros/capistrano-sidekiq"
end
