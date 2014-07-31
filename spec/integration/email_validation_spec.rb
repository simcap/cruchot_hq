require 'spec_helper'
require_relative '../../app'

describe "Email validation" do
  include Rack::Test::Methods

  def app
    CruchotHq::App  
  end

  it "returns 200 for valid email" do
    get '/email/validation', email: 'valid@mail.com'
    expect(last_response).to be_ok
  end

  it "returns 400 with error message for invalid email" do
    %w(invalid@mail @mail.com invalid invalid@.com).each do |email|
      get '/email/validation', email: email
      expect(last_response.status).to eql 400
      expect(last_response.body).to match /invalid email syntax.*#{email}/i 
    end
  end

end
