require 'sinatra'
require 'json'
require 'redis'

require_relative 'lib/validators'
require_relative 'lib/token_authentication'

module CruchotHq
  class Api < Sinatra::Application
  
    use TokenAuthentication 

    before do
      content_type 'application/json'
    end

    EMAIL = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

    get '/validation' do
      if email_syntax.invalid?
        json_response(email_syntax.errors)
      elsif email_domain.invalid?
        json_response(email_domain.errors)
      else
        json_response 
      end
    end

    def json_response(errors = []) 
      if errors.empty?
        [200, {email: params[:email], status: 'ok'}.to_json]
      else
        [202, {email: params[:email], status: 'error', message: errors.first}.to_json]
      end 
    end

    def email_syntax
      @syntax_validator ||= EmailSyntaxValidator.new(params[:email]) 
    end

    def email_domain
      @domain_validator ||= EmailDomainValidator.new(params[:email]) 
    end

  end
end
