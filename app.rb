require 'sequel'
require 'sinatra/base'
require 'sinatra/json'

class App < Sinatra::Base
  configure do
    enable :logging
    set :logging, Logger::DEBUG
  end
  configure :production do
    set :logging, Logger::INFO
  end

  DB = Sequel.connect(
    adapter: 'mysql2',
    host: ENV.fetch('DB_HOSTNAME'),
    database: ENV.fetch('DB_NAME'),
    user: ENV.fetch('DB_USER'),
    password: ENV.fetch('DB_PASS')
  )

  get '/authorize/user/:user_name' do
    authorize_user(params['user_name'])
  end

  get '/authorize/user/:user_name/*' do
    authorize_user(params['user_name'])
  end

private

  def authorize_user(user_name)
    user = user_from_db(user_name)
    return 404 unless user
    json "control:Cleartext-Password": user[:password]
  end

  def user_from_db(user_name)
    DB[:userdetails].select(Sequel[:password]).first(username: user_name)
  end
end
