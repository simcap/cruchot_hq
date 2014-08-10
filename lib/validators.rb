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
    if Resolv::DNS.new.getresources(domain, Resolv::DNS::Resource::IN::MX).empty?
      errors << 'invalid email domain'
    end
  rescue Resolv::ResolvError, Resolv::ResolvTimeout
      errors << 'invalid email domain'
  end

  def domain
    @domain ||= subject.split('@').last
  end

end
