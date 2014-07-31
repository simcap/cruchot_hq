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

end
