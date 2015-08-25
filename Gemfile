source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
gem 'bootstrap-sass'
gem 'bootstrap-sass-extras'
gem 'slim-rails'
gem 'devise'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'private_pub'
gem 'thin'
gem 'responders'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'cancancan'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'whenever'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'will_paginate', '~> 3.0.6'
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'

# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
group :development do
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'spring-commands-rspec'
  gem 'letter_opener'
  gem 'capybara-email'

  # Checks ruby code grammar
  gem 'rubocop', require: false
  # With rspec
  gem 'rubocop-rspec'
  # With guard
  gem 'guard-rubocop'
end

group :test do
  gem 'shoulda-matchers'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'json_spec'
end
