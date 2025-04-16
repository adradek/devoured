source "https://rubygems.org"

ruby "2.7.8"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.0.5"

gem "actionpack-action_caching"

gem "activerecord", "~> 6.0.5.1"
gem "pg", "~> 0.18"
gem "puma", "~> 6.4.0"
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem "webpacker", "~> 4.0"

gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0.0"
gem "dalli"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

gem "sorcery"
gem "pundit"

gem "websocket-extensions", "~> 0.1.5"

gem "newrelic_rpm"

gem "rack-mini-profiler"
# gem 'flamegraph'
gem "stackprof"

group :production do
  gem "rails_12factor"
end

group :development, :test do
  gem "byebug", platform: :mri
  gem "pry"
  gem "pry-byebug"
  gem "pry-rails"
  gem "pry-remote"
  gem "memory_profiler"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "bullet"
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", "~> 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "rails-erd"
  gem "railroady"
  gem "annotate"
  gem "flay", require: false
  gem "reek", "~> 6.1.0", require: false
  gem "brakeman"
  gem "bundler-audit"
end

group :test do
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0.0"
  gem "capybara", ">= 2.15"
  gem "selenium-webdriver"
  # Easy installation and use of web drivers to run system tests with browsers
  gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
