require 'sinatra'
require 'json'
require_relative 'lib/email_syntax_validator'
require_relative 'lib/email_domain_validator'

module CruchotHq
  class App < Sinatra::Application
  
    before do
      content_type 'application/json'
    end

    EMAIL = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

    get '/email/validation' do
      if !email_syntax_validator.valid?
        status 400
        body json_body(email_syntax_validator.errors)
      elsif !email_domain_validator.valid?
        status 400
        body json_body(email_domain_validator.errors)
      else
        status 200
        body json_body []
      end
    end

    def json_body(errors)
      if errors.empty?
        {email: params[:email], status: 'ok'}.to_json
      else
        {email: params[:email], status: 'error', message: errors.first}.to_json
      end 
    end

    def email_syntax_validator
      @syntax_validator ||= EmailSyntaxValidator.new(params[:email]) 
    end

    def email_domain_validator
      @domain_validator ||= EmailDomainValidator.new(params[:email]) 
    end

  end
end
