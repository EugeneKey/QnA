# README

This app based on main idea of stackowerflow: people can ask questions and create answers for them, created for lerning how some gems and technologies works.

### Features:

**Actions mostly works without reload (ajax) New records appears on page without reload for all users (comet) Faye through private pub**

  - gem 'private_pub'
  - gem 'thin'

**Authentication**

  - gem 'devise'
  - gem 'omniauth'
  - gem 'omniauth-facebook'
  - gem 'omniauth-twitter'

**Authorization with Policies**

  - gem 'cancancan'

**App has REST API**

  - gem 'active_model_serializers'
  - gem 'doorkeeper'

**Attach files to questions/answers**

  - gem 'carrierwave'

**Background jobs (like email)**

  - gem 'sidekiq'
  - gem 'whenever'
  - ActiveJob

**Redis for sidekiq and caching**

  - Fragment caching (Russian doll caching)
  - gem 'redis-rails'

**Sphinx search**

  - gem 'thinking-sphinx'

**Test Driven Developed more than 400 Rspec tests examples written before code**

  - gem 'rspec-rails'
  - gem 'factory_girl_rails'
  - gem 'shoulda-matchers'

**Feature (acceptance) testing with JS**

  - gem 'capybara'
  - gem 'capybara-webkit'

**Views written on Slim & Bootstrap**

  - gem 'slim'
  - gem 'bootstrap-sass'

**PostgreSQL as main db**

  - gem 'pg'

**Ready to Deploy**

  - gem 'capistrano'
  - gem 'therubyracer'

**Unicorn as production webserver**

  - gem 'unicorn'

### Ruby version

  - ruby 2.2.1


### Services (job queues, cache servers, search engines, etc.)

  - Postgres
  - Redis
  - Sidekiq
  - PrivatePub(thin)
  - Sphinx

### Deployment instructions

  - cap production deploy

### Development start instructions

  - rails s -b ip_address
  - rackup private_pub.ru - s thin -E development -o ip_address
  - rake ts:start - Sphinx
  - redis-server start
  - sideqik -q default -q mailer