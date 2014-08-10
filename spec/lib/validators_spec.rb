require 'validators'

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

describe EmailDomainValidator do

  let(:email) { 'valid@email.com' } 

  subject { described_class.new(email) }

  describe "#valid? & #invalid?" do
    it "returns true when domain valid" do
      validator = described_class.new('bob@gmail.com')
      expect(validator.valid?).to eql true
      expect(validator.invalid?).to eql false
      expect(validator.errors).to be_empty
    end

    it "returns false when domain invalid" do
      validator = described_class.new('bob@invaliddomain.com')
      expect(validator.valid?).to eql false
      expect(validator.invalid?).to eql true
      expect(validator.errors.size).to eql 1
      expect(validator.errors).to match_array ['invalid email domain']
    end

    [Resolv::ResolvError, Resolv::ResolvTimeout].each do |error|
      it "returns false when #{error} occurs" do
        expect_any_instance_of(Resolv::DNS).to receive(:getresources).and_raise(error)
        validator = described_class.new('bob@invaliddomain.com')
        expect(validator.valid?).to eql false
        expect(validator.errors.size).to eql 1
        expect(validator.errors).to match_array ['invalid email domain']
      end
    end
  end

end
