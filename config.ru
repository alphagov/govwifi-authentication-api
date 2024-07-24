DEPLOY_ENV = ENV['DEPLOY_ENV'] ||= 'development' unless defined?(DEPLOY_ENV)

if %w[production staging].include?(DEPLOY_ENV)
  require 'raven'

  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
  end

  use Raven::Rack
end

require './app'
run App
