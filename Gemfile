source "https://rubygems.org"

ruby '2.4.0'

gem "decidim", git: "https://github.com/AjuntamentdeBarcelona/decidim.git"
gem "decidim-debates", path: "engines/decidim-debates"

gem 'uglifier', '>= 1.3.0'


group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem "progressbar"
  gem 'rainbow', "2.1.0"
  gem "decidim-dev", git: "https://github.com/AjuntamentdeBarcelona/decidim.git"
  gem 'web-console'
  gem 'listen'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'faker'
  gem 'capistrano'
  gem 'capistrano3-puma'
  gem 'capistrano-bundler', '~> 1.2'
end

group :production do
  gem "puma"
  gem "sidekiq"
  gem "fog-aws"
  gem "newrelic_rpm"
  gem "dalli"
  gem "sentry-raven"
  gem "rack-host-redirect"
end

group :test do
  gem "rspec-rails"
  gem "database_cleaner"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
