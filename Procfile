web: bundle exec puma -t 3:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: bundle exec sidekiq
release: bundle exec rails db:migrate
