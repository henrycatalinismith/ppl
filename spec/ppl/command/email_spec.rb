
describe Ppl::Command::Email do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::Email.new
    @storage = double(Ppl::Adapter::Storage)

    @list_format = double(Ppl::Format::Contact)
    @show_format = double(Ppl::Format::Contact)

    @command.storage     = @storage
    @command.show_format = @show_format
    @command.list_format = @list_format
    @contact.id = "jim"
  end

  describe "#name" do
    it "should be 'email'" do
      @command.name.should eq "email"
    end
  end

  describe "#execute" do

    it "should list all email addresses if no contact ID is given" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process).and_return("all the email addresses")
      @output.should_receive(:line).with("all the email addresses")
      @input.arguments = []
      @command.execute(@input, @output)
    end

    it "should show the current address if no new address is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("jdoe@example.org")
      @output.should_receive(:line).with("jdoe@example.org")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq true
    end

    it "should not output anything if there's nothing to show" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq false
    end

    it "should delete the given address to the contact if requested" do
      @contact.email_addresses.push("jim@example.org")
      @contact.email_addresses.push("jim@example.com")
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.email_addresses.should eq ["jim@example.com"]
      end
      @input.arguments = ["jim", "jim@example.org"]
      @input.options   = { :delete => true }
      @command.execute(@input, @output)
    end

    it "should raise an error when deleting a non-existent email address" do
      @contact.email_addresses.push("jim@example.org")
      @contact.email_addresses.push("jim@example.com")
      @storage.should_receive(:require_contact).and_return(@contact)
      @input.arguments = ["jim", "jim@example.net"]
      @input.options   = { :delete => true }
      expect{@command.execute(@input, nil)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should add the given address to the contact if it's new" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.email_addresses.first.should eq "jim@example.org"
      end
      @input.arguments = ["jim", "jim@example.org"]
      @command.execute(@input, @output)
    end

    it "should raise an error if the user is adding a duplicate address" do
      @contact.email_addresses.push "jim@example.org"
      @storage.should_receive(:require_contact).and_return(@contact)
      @input.arguments = ["jim", "jim@example.org"]
      expect{@command.execute(@input, nil)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

  end

end

