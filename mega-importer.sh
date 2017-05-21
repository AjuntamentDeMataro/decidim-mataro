set -e
bundle exec rake db:drop db:create db:schema:load
bundle exec rake import:all
heroku pg:reset --app decidim-mataro --confirm decidim-mataro
heroku pg:push decidim-mataro_development DATABASE_URL
