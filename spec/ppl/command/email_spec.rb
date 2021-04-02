describe Ppl::Command::Email do

  before(:each) do
    @command = Ppl::Command::Email.new
  end

  describe "#name" do
    it "should be 'email'" do
      expect(@command.name).to eq "email"
    end
  end

  describe "#execute" do

    before(:each) do
      @contact = Ppl::Entity::Contact.new
      @service = double(Ppl::Service::EmailAddress)
      @storage = double(Ppl::Adapter::Storage)
      @input = Ppl::Application::Input.new
      @output = double(Ppl::Application::Output)
      @list_format = double(Ppl::Format::AddressBook)
      @show_format = double(Ppl::Format::Contact)
      @custom_format = double(Ppl::Format::Custom)
      allow(@storage).to receive(:require_contact).and_return(@contact)
      allow(@storage).to receive(:save_contact)
      @command.storage = @storage
      @command.email_service = @service
      @command.list_format = @list_format
      @command.show_format = @show_format
      @command.custom_format = @custom_format
    end

    it "should list all email addresses by default" do
      expect(@storage).to receive(:load_address_book).and_return(@address_book)
      expect(@list_format).to receive(:process).and_return("imagine this is a list")
      expect(@output).to receive(:line).with("imagine this is a list")
      @command.execute(@input, @output)
    end

    it "should show a single contact's addresses if one is specified" do
      @input.arguments << "jdoe"
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@show_format).to receive(:process).and_return("imagine this is a list")
      expect(@output).to receive(:line).with("imagine this is a list")
      @command.execute(@input, @output)
    end

    it "should output addresses in a custom format if one is given" do
      @input.arguments << "jdoe"
      @input.options[:format] = "%e"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("jdoe@example.org")
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@custom_format).to receive(:format=).with("%e")
      expect(@custom_format).to receive(:process).and_return("")
      expect(@output).to receive(:line).with("")
      @command.execute(@input, @output)
    end
    
    it "should delegate to the service layer to add a new email address" do
      @input.arguments = ["jdoe", "jdoe@example.org"]
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@service).to receive(:add).with(@contact, "jdoe@example.org", @input.options)
      @command.execute(@input, @output)
    end

    it "should delegate to the service layer to update an existing address" do
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("jdoe@example.org")
      @input.arguments = ["jdoe", "jdoe@example.org"]
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@service).to receive(:update).with(@contact, "jdoe@example.org", {})
      @command.execute(@input, @output)
    end

    it "should delegate to the service layer to remove an email address" do
      @input.arguments = ["jdoe", "jdoe@example.org"]
      @input.options[:delete] = true
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@service).to receive(:remove).with(@contact, "jdoe@example.org")
      @command.execute(@input, @output)
    end

  end

end

