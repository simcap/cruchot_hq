require 'resolv'

class EmailDomainValidator

  attr_reader :errors, :email

  def initialize(email)
    @email = email
    @errors = []
  end

  def valid?
    errors.clear
    validate 
    errors.empty?
  end

  private 

  # credit is due at https://gist.github.com/brianjlandau/da0bab27dcf1d8691f6e
  def validate
    if Resolv::DNS.new.getresources(domain, Resolv::DNS::Resource::IN::MX).empty?
      errors << 'invalid email domain'
    end
  rescue Resolv::ResolvError, Resolv::ResolvTimeout
      errors << 'invalid email domain'
  end

  def domain
    @domain ||= email.split('@').last
  end

end
