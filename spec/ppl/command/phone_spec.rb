
describe Ppl::Command::Phone do

  before(:each) do
    @command = Ppl::Command::Phone.new
  end

  describe "#name" do
    it "should be 'phone'" do
      @command.name.should eq "phone"
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
      @storage.stub(:require_contact).and_return(@contact)
      @storage.stub(:save_contact)
      @command.phone_service = @service
      @command.storage = @storage
      @command.list_format = @list_format
      @command.show_format = @show_format
    end

    it "should list all phone numbers by default" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process)
      @output.should_receive(:line)
      @command.execute(@input, @output)
    end

    it "should show a single contact's numbers if one is specified" do
      @input.arguments << "jdoe"
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process)
      @output.should_receive(:line)
      @command.execute(@input, @output)
    end

    it "should delegate to the service layer to remove a phone number" do
      @input.arguments = ["jdoe", "01234567890"]
      @input.options[:delete] = true
      @storage.should_receive(:require_contact).and_return(@contact)
      @service.should_receive(:remove).with(@contact, "01234567890")
      @command.execute(@input, @output)
    end

    it "should delegate to the service layer to add a new phone number" do
      @input.arguments = ["jdoe", "98776332"]
      @storage.should_receive(:require_contact).and_return(@contact)
      @service.should_receive(:add).with(@contact, "98776332", @input.options)
      @command.execute(@input, @output)
    end

    it "should delegate to the service layer to update an existing number" do
      @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("012345678")
      @input.arguments = ["jdoe", "012345678"]
      @storage.should_receive(:require_contact).and_return(@contact)
      @service.should_receive(:update).with(@contact, "012345678", {})
      @command.execute(@input, @output)
    end

  end

end

