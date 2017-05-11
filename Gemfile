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
gem "font-awesome-sass", "~> 4.7.0"
gem "select2-rails", "~> 4.0.3"
gem "jquery-ui-rails", "~> 5.0.5"
gem "glyphicons-rails"
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
gem "public_suffix", "~> 2.0"
gem "rinku", "~> 2.0.2"
gem "paperclip", "~> 5.0.0"
gem "aws-sdk", "~> 2.7"
gem "capybara"
gem "poltergeist"
gem "phantomjs", require: "phantomjs/poltergeist"
gem "rollbar", "~> 2.14"
gem "pundit", "~> 1.1.0"
gem "newrelic_rpm"
gem "typhoeus", "~> 1.1.2"
gem "switch_user"
gem "nested_form"
gem 'ckeditor'

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
  gem "letter_opener"
  gem "better_errors"
end
