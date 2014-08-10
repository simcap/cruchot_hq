ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'pry'
require 'redis'

REDIS = Redis.new

TEST_AUTH_TOKEN = '3456dfgh6789090uiygf'
ENV[TEST_AUTH_TOKEN] = 'cruchot_spec'

RSpec.configure do |config|
  config.before(:each, clear_redis: true) do
    clear_redis!
  end

  config.after(:suite) do
    clear_redis!
  end
end

def clear_redis!
  REDIS.del(:valid_email_domains)
  REDIS.del(:invalid_email_domains)
end
