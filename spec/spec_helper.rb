ENV['RACK_ENV'] = 'test'

require 'rack/test'
require 'pry'

require 'redis'

REDIS = Redis.new

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
