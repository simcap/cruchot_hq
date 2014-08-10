require 'sinatra'
require 'json'
require 'redis'
require 'erb'

module CruchotHq
  class Admin < Sinatra::Application

    enable :inline_templates

    get '/domains' do
      redis = Redis.new
      @valid_domains = redis.smembers(:valid_email_domains)
      @invalid_domains = redis.smembers(:invalid_email_domains)
      
      erb :domains
    end
  
  end
end

__END__
@@ domains
<p>Valid domains: <%= @valid_domains.join(', ') %></p>
<p>Invalid domains: <%= @invalid_domains.join(', ') %></p>
