
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

  describe "#has_email_address" do
    it "should know if the contact has the given email address" do
      @contact.email_addresses.push "test@example.org"
      @contact.has_email_address("test@example.org").should eq true
    end
    it "should know if the contact lacks the given email address" do
      @contact.has_email_address("test@example.org").should eq false
    end
  end

end

