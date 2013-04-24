
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

  describe "%N" do
    it "should output the contact's name" do
      @contact.name = "John Doe"
      @format.format = "%N"
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

  describe "%e" do
    before(:each) do
      @format.format = "%e"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("a@example.org")
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("b@example.org")
    end
    it "should output the first email address" do
      @format.process(@contact).should eq "a@example.org"
    end
    it "should output the preferred email address" do
      @contact.email_addresses[1].preferred = true
      @format.process(@contact).should eq "b@example.org"
    end
  end

  describe "%o" do
    it "should output the contact's organization" do
      @contact.organizations << "WTF Inc"
      @format.format = "%o"
      @format.process(@contact).should eq "WTF Inc"
    end
  end

end


