require 'sequel'
require 'sinatra/base'
require 'sinatra/json'

class App < Sinatra::Base
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

  def connect_to_db
    Sequel.connect(
      adapter: 'mysql2',
      host: ENV.fetch('DB_HOSTNAME'),
      database: ENV.fetch('DB_NAME'),
      user: ENV.fetch('DB_USER'),
      password: ENV.fetch('DB_PASS')
    )
  end

  def user_from_db(user_name)
    db = connect_to_db
    db[:userdetails].select(Sequel[:password]).first(username: user_name)
  end
end
