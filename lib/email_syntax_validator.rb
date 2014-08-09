class EmailSyntaxValidator

  EMAIL_REGEX = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

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

  def validate
    errors << 'incorrect email syntax' if EMAIL_REGEX  !~ email
  end

end
