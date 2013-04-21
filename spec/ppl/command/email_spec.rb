
describe Ppl::Command::Email do

  before(:each) do
    @command = Ppl::Command::Email.new
  end

  describe "#name" do
    it "should be 'email'" do
      @command.name.should eq "email"
    end
  end

  describe "#execute" do

    before(:each) do
      @contact = Ppl::Entity::Contact.new
      @storage = double(Ppl::Adapter::Storage)
      @input = Ppl::Application::Input.new
      @input.arguments = ["jdoe", "bob@example.org"]
      @storage.stub(:require_contact).and_return(@contact)
      @storage.stub(:save_contact)
      @command.storage = @storage
    end

    it "should save email addresses as instances of Ppl::Entity::EmailAddress" do
      @storage.should_receive(:save_contact) do |c|
        c.email_addresses.first.should be_a(Ppl::Entity::EmailAddress)
      end
      @command.execute(@input, @output)
    end

    it "should save the given address as an attribute of the EmailAddress" do
      @storage.should_receive(:save_contact) do |c|
        c.email_addresses.first.address.should eq "bob@example.org"
      end
      @command.execute(@input, @output)
    end

    it "shouldn't duplicate the address if the contact already has it" do
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("bob@example.org")
      @storage.should_receive(:save_contact) do |c|
        c.email_addresses.length.should eq 1
      end
      @command.execute(@input, @output)
    end

    it "should delete the given email address from the contact" do
      @input.arguments = ["jdoe", "bob@example.org"]
      @input.options[:delete] = "true"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("bob@example.org")
      @storage.should_receive(:save_contact) do |c|
        c.email_addresses.length.should eq 0
      end
      @command.execute(@input, @output)
    end

  end

end

