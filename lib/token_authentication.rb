class TokenAuthentication

  FORBIDDEN = [401, {"Content-Type" => "text/html"}, []].freeze
  AUTH_TOKEN_PARAM = 'auth_token'.freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    req = Rack::Request.new(env)
    token = req.params[AUTH_TOKEN_PARAM]
    if token && ENV[token]
      @app.call(env)
    else
      FORBIDDEN 
    end
  end

end
