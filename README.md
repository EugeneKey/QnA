# README

This app based on main idea of stackowerflow: people can ask questions and create answers for them, created for lerning how some gems and technologies works.

### Features:

**Actions mostly works without reload (ajax) New records appears on page without reload for all users (comet) Faye through private pub**

  - gem 'private_pub'
  - gem 'puma'

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

**Different production webserver**
  
  - gem 'puma'
  - gem 'unicorn'
  - gem 'passenger'

### Ruby & Rails version

  - ruby 2.4.0
  - rails 4.2.8


### Services (job queues, cache servers, search engines, etc.)

  - Postgres
  - Redis
  - Sidekiq
  - WebSockets with PrivatePub(thin)
  - Sphinx

### Deployment instructions

  - cap production deploy

### Development instructions (how to run on local machine)

**System requirements** 

- Unix like OS
- Redis (http://redis.io)
- Sphinx (http://sphinxsearch.com)
- PostgreSQL (http://postgresql.org)
- MySQL (http://mysql.com)

<details>
  <summary>[open ▾] How to check required software?</summary>

```
$ type rvm
/home/USER/.rvm/bin/rvm

$ type redis-server
/usr/bin/redis-server

$ type searchd
/usr/bin/searchd

$ type psql
/usr/bin/psql

$ type mysql
/usr/bin/mysql
```

</details>

Config files:

  - config/database.yml
  - config/private_pub.yml

copy and edit this files from .sample:

```  
cp config/database.yml.sample config/database.yml
cp config/private_pub.yml.sample config/private_pub.yml
```  

if you run app isn't on localhost (127.0.0.1) address please edit .env file:

```
IP_APP_DEV=127.0.0.1
```

initial:

```
  bundle update
  rake db:create
  rake db:migrate
  rake ts:index
```

run app with `foreman`

```
foreman start -f Procfile.dev
```  

run test:
```
rspec
```  

**Finally App is ready to use**

```
http://localhost:3000
```