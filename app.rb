require 'sinatra'

module CruchotHq
  class App < Sinatra::Application

    get '/email/validation' do
      status 200
    end
  end
end
