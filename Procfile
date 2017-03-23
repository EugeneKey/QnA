web: bin/rails server -p $PORT -e $RAILS_ENV
private_pub: rackup private_pub.ru -s puma -E production -p 9292
worker: bundle exec sidekiq -c 5 -v -q mailers -q default