def next?
  File.basename(__FILE__) == "Gemfile.next"
end

source "https://rubygems.org"

gem "concurrent-ruby", "~> 1.3.4"
gem "psych", "~> 5.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem "rails", "~> 8.1.0"

# The modern asset pipeline for Rails [https://github.com/rails/propshaft]
gem "propshaft"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"
gem "pg", "~> 1.5"

gem "actionpack-action_caching"
gem "puma", "~> 7.1.0"
# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "importmap-rails"
# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"
# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder"
gem "redis", "~> 5.4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

gem "dalli"

# TODO: Uncomment after Ruby and Rails updates + in boot.rb
# gem "bootsnap", require: false

# Deploy this application anywhere as a Docker container [https://kamal-deploy.org]
gem "kamal", require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem "thruster", require: false

gem "sorcery"
gem "pundit"

# TODO: Uncomment after Ruby and Rails updates
# gem "websocket-extensions", "~> 0.1.5"
# gem "newrelic_rpm"
# gem "rack-mini-profiler"

# gem 'flamegraph'
gem "stackprof"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[mswin jruby]

# Use the database-backed adapters for Rails.cache, Active Job, and Action Cable
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Use Sass to process CSS
gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

gem "webpacker", "~> 5.0"

gem "abbrev"

group :production do
  gem "rails_12factor"
end

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[mri mswin], require: "debug/prelude"
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem "brakeman", require: false
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
  # gem "web-console"
  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  gem "listen", "~> 3.2"
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "rails-erd"
  # gem "railroady"
  # gem "annotate", require: false + => lib/tasks/auto_annotate...
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
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  # gem "capybara"
  # gem "selenium-webdriver"
  # # Easy installation and use of web drivers to run system tests with browsers
  # gem "webdrivers"
end
