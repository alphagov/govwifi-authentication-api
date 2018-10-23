require 'sequel'
require 'sinatra/base'
require 'sinatra/json'
require 'semantic_logger'

class SemanticLoggerMiddleware
  def initialize(app, logger: nil)
    @app = app
    @logger = logger
  end

  def call(env)
    env['rack.logger'] = @logger
    env['Request-ID'] ||= SecureRandom.hex(8)

    @logger.tagged(request_id: env['Request-ID']) do
      log_start(env)
      @app.call(env).tap do |status, headers, _body|
        log_end(env, status, headers)
      end
    end
  end

  private

  def log_start(env)
    @logger.info(
      'Request started',
      address: env['HTTP_X_FORWARDED_FOR'] || env["REMOTE_ADDR"] || "-",
      user: env["REMOTE_USER"] || "-",
      time: Time.now.strftime("%d/%b/%Y:%H:%M:%S %z"),
      method: env['REQUEST_METHOD'],
      path: env['PATH_INFO'],
      query: env['QUERY_STRING'],
      http_version: env['HTTP_VERSION'],
    )
  end

  def log_end(env, status, headers)
    @logger.info(
      'Request finished',
      status: status.to_s[0..3],
      length: headers['Content-Length'] || '-',
    )
  end
end


class App < Sinatra::Base
  set :logger, SemanticLogger[App]

  configure do
    SemanticLogger.default_level = :debug
    SemanticLogger.add_appender(io: STDOUT, formatter: :color)

    use SemanticLoggerMiddleware, logger: logger
  end

  configure :production do
    SemanticLogger.default_level = :info
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
