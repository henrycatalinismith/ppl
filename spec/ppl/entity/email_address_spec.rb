describe Ppl::Entity::EmailAddress do

  before(:each) do
    @email_address = Ppl::Entity::EmailAddress.new
  end

  describe "#address" do
    it "should return a value" do
      expect(@email_address.address).to eq nil
    end
  end

  describe "#preferred" do
    it "should be false by default" do
      expect(@email_address.preferred).to eq false
    end
  end

  describe "#initialize" do
    it "should accept an address" do
      email = Ppl::Entity::EmailAddress.new("bob@example.org")
      expect(email.address).to eq "bob@example.org"
    end
  end

end

