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
    user = User.find(username: user_name)

    return 404 unless user

    user.update(last_login: Time.now) unless user_name == 'HEALTH'

    json "control:Cleartext-Password": user.password
  end
end
