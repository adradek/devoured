def next?
  File.basename(__FILE__) == "Gemfile.next"
end
source "https://rubygems.org"

ruby "3.1.7"

git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "concurrent-ruby", "1.3.4"
gem "psych", "~> 3.3"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 6.1.7"
gem "pg", "~> 1.1.0"

gem "actionpack-action_caching"
gem "puma", "~> 6.4.0"
gem "sass-rails", ">= 6"
gem "webpacker", "~> 5.0"

gem "jbuilder", "~> 2.7"
gem "redis", "~> 4.0.0"
gem "dalli"

# TODO: Uncomment after Ruby and Rails updates + in boot.rb
# gem "bootsnap", ">= 1.4.4", require: false

gem "sorcery"
gem "pundit"

# TODO: Uncomment after Ruby and Rails updates
# gem "websocket-extensions", "~> 0.1.5"
# gem "newrelic_rpm"
# gem "rack-mini-profiler"

# gem 'flamegraph'
gem "stackprof"

group :production do
  gem "rails_12factor"
end

group :development, :test do
  # gem "byebug", platform: :mri
  # gem "pry"
  # gem "pry-byebug"
  # gem "pry-rails"
  # gem "pry-remote"
  # gem "memory_profiler"
  # gem "rspec-rails"
  # gem "factory_bot_rails"
  # gem "faker"
  # gem "bullet" + in development.rb
  gem "next_rails"
end

group :development do
  # gem "web-console", ">= 4.1.0"
  gem "listen", "~> 3.2"
  # gem "spring"
  # gem "rails-erd"
  # gem "railroady"
  # gem "annotate", require: false
  # gem "flay", require: false
  # gem "reek", "~> 6.1.0", require: false
  # gem "brakeman", require: false
  gem "bundler-audit", require: false
  # gem "lefthook", require: false
  # gem "database_consistency", require: false
end

group :test do
  # gem "simplecov"
  # gem "codeclimate-test-reporter", "~> 1.0.0"
  # gem "capybara", ">= 3.26"
  # gem "selenium-webdriver", ">= 4.0.0.rc1"
  # # Easy installation and use of web drivers to run system tests with browsers
  # gem "webdrivers"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
