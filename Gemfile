source "https://rubygems.org"

gem "rails", "~> 5.0.0", ">= 5.0.0.1"
gem "mysql2"
gem "puma", "~> 3.0"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.2"
gem "jquery-rails"
gem "turbolinks", "~> 5"
gem "jquery-turbolinks"
gem "bootstrap-sass",          "3.2.0.0"
gem "jbuilder", "~> 2.5"
gem "devise"
gem "devise-async"
gem "figaro"
gem "sidekiq"
gem "gmaps4rails"
gem "geocoder"
gem "faker"
gem "config"

group :development, :test do
  gem "byebug", platform: :mri
  gem "factory_girl_rails"
  gem "rspec-rails", "~> 3.5"
  gem "pry-rails"
end

group :development do
  gem "web-console"
  gem "listen", "~> 3.0.5"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "spring-commands-rspec"
end

group :test do
  gem "database_cleaner"
  gem "shoulda-matchers", github: "thoughtbot/shoulda-matchers"
  gem "rails-controller-testing"
  gem "simplecov", require: false
  gem "rspec-activemodel-mocks"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]