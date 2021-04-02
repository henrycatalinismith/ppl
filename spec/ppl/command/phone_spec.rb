describe Ppl::Command::Phone do

  before(:each) do
    @command = Ppl::Command::Phone.new
  end

  describe "#name" do
    it "should be 'phone'" do
      expect(@command.name).to eq "phone"
    end
  end

  describe "#execute" do

    before(:each) do
      @contact = Ppl::Entity::Contact.new
      @service = double(Ppl::Service::PhoneNumber)
      @storage = double(Ppl::Adapter::Storage)
      @list_format = double(Ppl::Format::AddressBook)
      @show_format = double(Ppl::Format::Contact)
      @input = Ppl::Application::Input.new
      @output = double(Ppl::Application::Output)
      allow(@storage).to receive(:require_contact).and_return(@contact)
      allow(@storage).to receive(:save_contact)
      @command.phone_service = @service
      @command.storage = @storage
      @command.list_format = @list_format
      @command.show_format = @show_format
    end

    it "should list all phone numbers by default" do
      expect(@storage).to receive(:load_address_book).and_return(@address_book)
      expect(@list_format).to receive(:process)
      expect(@output).to receive(:line)
      @command.execute(@input, @output)
    end

    it "should show a single contact's numbers if one is specified" do
      @input.arguments << "jdoe"
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@show_format).to receive(:process)
      expect(@output).to receive(:line)
      @command.execute(@input, @output)
    end

    it "should delegate to the service layer to remove a phone number" do
      @input.arguments = ["jdoe", "01234567890"]
      @input.options[:delete] = true
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@service).to receive(:remove).with(@contact, "01234567890")
      @command.execute(@input, @output)
    end

    it "should delegate to the service layer to add a new phone number" do
      @input.arguments = ["jdoe", "98776332"]
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@service).to receive(:add).with(@contact, "98776332", @input.options)
      @command.execute(@input, @output)
    end

    it "should delegate to the service layer to update an existing number" do
      @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("012345678")
      @input.arguments = ["jdoe", "012345678"]
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@service).to receive(:update).with(@contact, "012345678", {})
      @command.execute(@input, @output)
    end

  end

end

