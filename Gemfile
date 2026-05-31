source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.0"

gem "rails", "~> 7.1.0"
gem "pg"
gem "puma", "~> 6.0"
gem "rack-cors"
gem "redis", "~> 5.0"
gem "redis-client", "~> 0.22"
gem "dotenv-rails"
gem "bootsnap", require: false
gem "connection_pool", "~> 2.4"
gem "lograge"

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
end