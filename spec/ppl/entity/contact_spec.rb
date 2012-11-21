
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
    it "should be an array" do
      @contact.email_addresses.should be_an(Array)
    end
  end

  describe "#nicknames" do
    it "should be an array" do
      @contact.nicknames.should be_an(Array)
    end
  end

  describe "#organizations" do
    it "should be an array" do
      @contact.organizations.should be_an(Array)
    end
  end

  describe "#phone_numbers" do
    it "should be an array" do
      @contact.phone_numbers.should be_an(Array)
    end
  end

  describe "#postal_addresses" do
    it "should be an array" do
      @contact.postal_addresses.should be_an(Array)
    end
  end

end

