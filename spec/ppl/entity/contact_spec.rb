
describe Ppl::Entity::Contact do

  before(:each) do
    @contact = Ppl::Entity::Contact.new
  end

  describe "#id" do
    it "should return a value" do
      @contact.id.should be nil
    end
  end

  describe "#id=" do
    it "should accept a value" do
      @contact.id = "john"
      @contact.id.should eq "john"
    end
  end

  describe "#email_addresses" do
    it "should return an array" do
      @contact.email_addresses.should be_a(Array)
    end
  end

  describe "#birthday" do
    it "should return a value" do
      @contact.birthday.should eq nil
    end
  end

  describe "#postal_address" do
    it "should return a value" do
      @contact.postal_address.should eq nil
    end
  end

  describe "#urls" do
    it "should return an array" do
      @contact.urls.should be_a(Array)
    end
  end

  describe "#nicknames" do
    it "should return an array" do
      @contact.nicknames.should be_a(Array)
    end
  end

  describe "#organizations" do
    it "should return an array" do
      @contact.organizations.should be_a(Array)
    end
  end

  describe "#phone_numbers" do
    it "should return an array" do
      @contact.phone_numbers.should be_a(Array)
    end
  end

  describe "#age" do
    it "should return nil if the date of birth is unknown" do
      @contact.age(Date.today).should eq nil
    end
    it "should return the contact's age" do
      @contact.birthday = Date.parse("1970-01-01")
      @contact.age(Date.parse("1980-01-02")).should eq 10
    end
  end

  describe "#preferred_email_address" do

    before(:each) do
      @contact.email_addresses << Ppl::Entity::EmailAddress.new
    end

    it "returns nil if there's no preferred address" do
      @contact.preferred_email_address.should eq nil
    end

    it "returns the preferred email address" do
      @contact.email_addresses[0].preferred = true
      @contact.preferred_email_address.should be_a(Ppl::Entity::EmailAddress)
    end

  end

end

