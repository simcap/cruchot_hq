require 'spec_helper'
require_relative '../../api'

describe "Email validation" do
  include Rack::Test::Methods

  def app
    CruchotHq::Api  
  end

  def json_body
    JSON.parse(last_response.body)
  end

  it "returns 200 for valid email" do
    get '/validation', email: 'valid@mail.com'
    expect(last_response).to be_ok
    expect(json_body['email']).to eql 'valid@mail.com'
    expect(json_body['status']).to eql 'ok'
  end

  it "returns 400 with error message for invalid email syntax" do
    %w(invalid@mail @mail.com invalid invalid@.com).each do |email|
      get '/validation', email: email
      expect(last_response.status).to eql 202
      expect(json_body['email']).to eql email
      expect(json_body['status']).to eql 'error'
      expect(json_body['message']).to match /incorrect email syntax/i 
    end
  end

  it "returns 400 with error message for invalid email domain" do
    email = 'invalid@il.com'
    get '/validation', email: email
    expect(last_response.status).to eql 202
    expect(json_body['email']).to eql email
    expect(json_body['status']).to eql 'error'
    expect(json_body['message']).to match /invalid email domain/i 
  end

end
