
describe Ppl::Entity::EmailAddress do

  before(:each) do
    @email_address = Ppl::Entity::EmailAddress.new
  end

  describe "#address" do
    it "should return a value" do
      @email_address.address.should eq nil
    end
  end

  describe "#preferred" do
    it "should be fale by default" do
      @email_address.preferred.should eq false
    end
  end

  describe "#initialize" do
    it "should accept an address" do
      email = Ppl::Entity::EmailAddress.new("bob@example.org")
      email.address.should eq "bob@example.org"
    end
  end

end

