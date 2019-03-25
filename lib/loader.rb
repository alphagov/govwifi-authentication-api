require 'sequel'
require 'sensible_logging'
require 'sinatra/base'
require 'sinatra/json'
require 'logger'
require 'require_all'

DB = Sequel.connect(
  adapter: 'mysql2',
  host: ENV.fetch('DB_HOSTNAME'),
  database: ENV.fetch('DB_NAME'),
  user: ENV.fetch('DB_USER'),
  password: ENV.fetch('DB_PASS'),
  max_connections: 16,
)

require_all 'lib'
