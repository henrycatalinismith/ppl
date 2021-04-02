describe Ppl::Entity::Contact do

  before(:each) do
    @contact = Ppl::Entity::Contact.new
  end

  describe "#id" do
    it "should return a value" do
      expect(@contact.id).to be nil
    end
  end

  describe "#id=" do
    it "should accept a value" do
      @contact.id = "john"
      expect(@contact.id).to eq "john"
    end
  end

  describe "#email_addresses" do
    it "should return an array" do
      expect(@contact.email_addresses).to be_a(Array)
    end
  end

  describe "#postal_addresses" do
    it "should return an array" do
      expect(@contact.postal_addresses).to be_a(Array)
    end
  end

  describe "#birthday" do
    it "should return a value" do
      expect(@contact.birthday).to eq nil
    end
  end

  describe "#postal_address" do
    it "should return a value" do
      expect(@contact.postal_address).to eq nil
    end
  end

  describe "#urls" do
    it "should return an array" do
      expect(@contact.urls).to be_a(Array)
    end
  end

  describe "#nicknames" do
    it "should return an array" do
      expect(@contact.nicknames).to be_a(Array)
    end
  end

  describe "#organizations" do
    it "should return an array" do
      expect(@contact.organizations).to be_a(Array)
    end
  end

  describe "#phone_numbers" do
    it "should return an array" do
      expect(@contact.phone_numbers).to be_a(Array)
    end
  end

  describe "#age" do
    it "should return nil if the date of birth is unknown" do
      expect(@contact.age(Date.today)).to eq nil
    end
    it "should return the contact's age" do
      @contact.birthday = Date.parse("1970-01-01")
      expect(@contact.age(Date.parse("1980-01-02"))).to eq 10
    end
  end

  describe "#preferred_email_address" do

    before(:each) do
      @contact.email_addresses << Ppl::Entity::EmailAddress.new
    end

    it "returns nil if there's no preferred address" do
      expect(@contact.preferred_email_address).to eq nil
    end

    it "returns the preferred email address" do
      @contact.email_addresses[0].preferred = true
      expect(@contact.preferred_email_address).to be_a(Ppl::Entity::EmailAddress)
    end

  end

  describe "#preferred_phone_number" do

    before(:each) do
      @contact.phone_numbers << Ppl::Entity::PhoneNumber.new
    end

    it "returns nil if there's no preferred number" do
      expect(@contact.preferred_phone_number).to eq nil
    end

    it "returns the preferred phone number" do
      @contact.phone_numbers[0].preferred = true
      expect(@contact.preferred_phone_number).to be_a(Ppl::Entity::PhoneNumber)
    end

  end

end

