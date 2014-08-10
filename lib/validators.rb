require 'resolv'

class BaseValidator

  attr_reader :subject, :errors

  def initialize(subject)
    @subject = subject
    @errors = []
  end

  def valid?
    errors.clear
    validate_subject
    errors.empty?
  end

  def invalid?
    !valid?
  end

end

class EmailSyntaxValidator < BaseValidator

  EMAIL_REGEX = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

  private 

  def validate_subject
    errors << 'incorrect email syntax' if EMAIL_REGEX  !~ subject
  end

end

class EmailDomainValidator < BaseValidator

  private 

  # credit is due at https://gist.github.com/brianjlandau/da0bab27dcf1d8691f6e
  def validate_subject
    errors << 'invalid email domain' unless domain_valid?
  end

  def domain
    @domain ||= subject.split('@').last
  end

  def redis
    @redis ||= Redis.new
  end

  def domain_valid?
    if redis.sismember(:valid_email_domains, domain)
      true
    elsif redis.sismember(:invalid_email_domains, domain)
      false
    else
      perform_dns_query!
    end
  end

  def perform_dns_query!
    if Resolv::DNS.new.getresources(domain, Resolv::DNS::Resource::IN::MX).empty?
      redis.sadd(:invalid_email_domains, domain)
      false 
    else
      redis.sadd(:valid_email_domains, domain)
      true
    end
  rescue Resolv::ResolvError, Resolv::ResolvTimeout
    redis.sadd(:invalid_email_domains, domain)
    false
  end

end
