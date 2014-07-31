require 'sinatra'

module CruchotHq
  class App < Sinatra::Application
  
    EMAIL = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

    get '/email/validation' do
      email = params[:email]
      if email =~ EMAIL
        status 200
      else
        status 400
        body "Invalid email syntax for #{email}"
      end
    end
  end
end
