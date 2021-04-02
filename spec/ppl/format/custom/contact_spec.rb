describe Ppl::Format::Custom::Contact do

  before(:each) do
    @format = Ppl::Format::Custom::Contact.new
    @contact = Ppl::Entity::Contact.new
  end

  describe "%n" do
    it "should be replaced with a newlines" do
      @format.format = "%n"
      @format.process(@contact).should eq "\n"
    end
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

  describe "%k" do
    it "should output the contact's nickname" do
      @contact.nicknames << "Johnny"
      @format.format = "%k"
      @format.process(@contact).should eq "Johnny"
    end
  end

  describe "%a" do
    it "should output the contact's age" do
      @contact.birthday = Date.parse("2000-01-01")
      Date.stub(:today).and_return(Date.parse("2010-01-02"))
      @format.format = "%a"
      @format.process(@contact).should eq "10"
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

  describe "%p" do
    before(:each) do
      @format.format = "%p"
      @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("0123456789")
      @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("1098765432")
    end
    it "should output the first phone number" do
      @format.process(@contact).should eq "0123456789"
    end
    it "should output the preferred phone number" do
      @contact.phone_numbers[1].preferred = true
      @format.process(@contact).should eq "1098765432"
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


