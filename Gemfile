# frozen_string_literal: true
source 'https://rubygems.org'
ruby '2.4.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'

### FRONT
# sass-powered version of Bootstrap 3
gem 'bootstrap-sass'
gem 'bootstrap-sass-extras'
# slim template language for HTML
gem 'slim-rails'
# SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Uglifier as a compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# jquery as a the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster.
# Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# jquery for turbolinks
gem 'jquery-turbolinks'
# Dynamic nested forms using jQuery
gem 'cocoon'
# Pagination library for Rails
gem 'will_paginate', '~> 3.1.1'

# for files uploads
gem 'carrierwave'
gem 'jasny-bootstrap-rails'
# AJAX file uploads with jQuery
gem 'remotipart'

### APP SERVER
gem 'puma'

### DATABASES & SEARCH
# Use postgresql as the database for Active Record
gem 'mysql2' # for install sphinx
gem 'pg'
gem 'redis-rails' # for caching
gem 'thinking-sphinx' # for search engines Sphinx

### COMET with WEBSOCKETS
gem 'private_pub'

### AUTHENTICATION
gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'

### AUTHORIZATION
gem 'cancancan'

### REST API
gem 'active_model_serializers'
gem 'doorkeeper'
# Optimized JSON: fast JSON parser and Object marshaller
gem 'oj'
gem 'oj_mimic_json'

### BACKGROUND JOB
gem 'sidekiq'
gem 'whenever'

# responders modules to dry up your Rails controller
gem 'responders'

# minimal two way bridge between the V8 JavaScript engine and Ruby
gem 'mini_racer', platforms: :ruby

### CONFIG
gem 'dotenv'
gem 'dotenv-rails', require: 'dotenv/rails-now'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# generates fake data
gem 'faker'
gem 'populator'

group :development do
  # Use Capistrano for deployment
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano3-puma',   require: false
  gem 'capistrano-sidekiq', require: false

  # Annotate Rails classes with schema and routes info
  gem 'annotate'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Manage Procfile-based applications
  gem 'foreman'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution
  # and get a debugger console
  gem 'byebug'

  # Spring speeds up development
  # by keeping your application running in the background.
  # Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'capybara-email'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'letter_opener'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'

  # Checks ruby code grammar
  gem 'rubocop', require: false
  # With rspec
  gem 'rubocop-rspec'
  # With guard
  gem 'guard-rubocop'

end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'shoulda-matchers'

  gem 'capybara-webkit' # need install Qt and QtWebKit
  # sudo apt-get install qt5-default libqt5webkit5-dev

  gem 'headless' # need install xvfb
  # sudo apt-get install xvfb

  gem 'database_cleaner'
  gem 'json_spec'
end
