source 'https://rubygems.org'

ruby '2.5.9'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.0'
gem 'pg', '~> 0.18'
gem 'puma', '~> 4.3'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'sorcery'
gem 'bootstrap-sass', '~> 3.4.1'
gem 'font-awesome-rails', '~> 4.7.0'
gem 'pundit'

gem 'websocket-extensions', '~> 0.1.5'

group :production do
  gem 'rails_12factor'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'pry'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'rack-mini-profiler'
  # gem 'flamegraph'
  # gem 'stackprof'
  gem 'memory_profiler'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'bullet'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem "rails-erd"
  gem 'railroady'
  gem 'annotate'
end

group :test do
  gem "simplecov"
  gem "codeclimate-test-reporter", "~> 1.0.0"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
