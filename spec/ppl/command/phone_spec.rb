
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
      @storage = double(Ppl::Adapter::Storage)
      @list_format = double(Ppl::Format::AddressBook)
      @show_format = double(Ppl::Format::Contact)
      @input = Ppl::Application::Input.new
      @output = double(Ppl::Application::Output)
      @storage.stub(:require_contact).and_return(@contact)
      @storage.stub(:save_contact)
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

  end

end

