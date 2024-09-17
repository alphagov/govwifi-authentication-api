RACK_ENV = ENV['RACK_ENV'] ||= 'development' unless defined?(RACK_ENV)

if ENV.key?("SENTRY_DSN")
  require "sentry-ruby"

  Sentry.init do |config|
    config.dsn = ENV["SENTRY_DSN"]
    config.send_default_pii = true
  end
end

require './app'
run App
