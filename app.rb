require './lib/loader'

class App < Sinatra::Base
  register Sinatra::SensibleLogging

  sensible_logging(
    logger: Logger.new(STDOUT)
  )

  configure do
    set :log_level, Logger::DEBUG
  end

  configure :production do
    set :log_level, Logger::INFO
  end

  configure :production, :staging do
    set :dump_errors, false
  end

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

    touch_last_login(user)

    json "control:Cleartext-Password": user.password
  end

  def user_from_db(user_name)
    User.find(username: user_name)
  end

  def touch_last_login(user)
    user.last_login = Time.now
    user.save
  end
end
