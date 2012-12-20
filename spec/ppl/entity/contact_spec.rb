
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

  describe "#email_address" do
    it "should return a value" do
      @contact.email_address.should eq nil
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

end

