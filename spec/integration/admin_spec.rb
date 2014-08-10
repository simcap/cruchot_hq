require 'spec_helper'
require_relative '../../admin'

describe "Admin application" do
  include Rack::Test::Methods

  def app
    CruchotHq::Admin
  end

  before do
    REDIS.sadd(:valid_email_domains, ['gmail.com', 'hotmail.com'])
    REDIS.sadd(:invalid_email_domains, ['pt.com', 'il.com'])
  end

  it "returns email domains processed" do
    get '/domains'
    body = last_response.body
    expect(body).to match /Valid.*hotmail\.com, gmail\.com/
    expect(body).to match /Invalid.*il\.com, pt\.com/
  end

end
