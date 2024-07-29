RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)

if %w[production staging].include?(DEPLOY_ENV)
  require 'raven'

  Raven.configure do |config|
    config.dsn = ENV['SENTRY_DSN']
  end

  use Raven::Rack
end

require './app'
run App
