require 'email_syntax_validator'

describe EmailSyntaxValidator do

  let(:email) { 'valid@email.com' } 

  subject { described_class.new(email) }

  describe "#valid? & #invalid?" do
    it "is idempotent" do
      validator = described_class.new('invalid@mail')
      expect(validator.valid?).to eql false
      expect(validator.errors.size).to eql 1
      expect(validator.invalid?).to eql true
      expect(validator.errors.size).to eql 1
      expect(validator.valid?).to eql false
      expect(validator.errors.size).to eql 1
      expect(validator.invalid?).to eql true
      expect(validator.errors.size).to eql 1
    end

    it "returns true when email valid" do
      validator = described_class.new('valid@mail.com')
      expect(validator.valid?).to eql true
      expect(validator.invalid?).to eql false
    end
  end

  describe "Incorrect email syntax" do
    it "populates with error invalid syntax" do
      validator = described_class.new('invalid@mail')
      expect(validator.valid?).to eql false
      expect(validator.invalid?).to eql true
      expect(validator.errors.size).to eql 1
      expect(validator.errors).to match_array ['incorrect email syntax']
    end
  end
end
