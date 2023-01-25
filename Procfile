web: bundle exec puma -t 3:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq -q default -q mailers -c 3
release: bundle exec rails db:migrate
