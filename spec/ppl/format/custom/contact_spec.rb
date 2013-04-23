
describe Ppl::Format::Custom::Contact do

  before(:each) do
    @format = Ppl::Format::Custom::Contact.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "%i" do
    it "should output the contact's ID" do
      @contact.id = "test"
      @format.format = "%i"
      @format.process(@contact).should eq "test"
    end
  end

  describe "%n" do
    it "should output the contact's name" do
      @contact.name = "John Doe"
      @format.format = "%n"
      @format.process(@contact).should eq "John Doe"
    end
  end

  describe "%b" do
    it "should output the contact's birthday" do
      @contact.birthday = Date.parse("1985-06-07")
      @format.format = "%b"
      @format.process(@contact).should eq "1985-06-07"
    end
    it "should cause no errors if there's no birthday" do
      @contact.birthday = nil
      @format.format = "%b"
      @format.process(@contact).should eq ""
    end
  end

end


