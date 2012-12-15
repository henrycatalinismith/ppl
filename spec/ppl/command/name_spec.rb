
describe Ppl::Command::Name do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::Name.new

    @address_book = Ppl::Entity::AddressBook.new

    @storage     = double(Ppl::Adapter::Storage)
    @show_format = double(Ppl::Format::Contact)
    @list_format = double(Ppl::Format::Contact)

    @command.storage     = @storage
    @command.show_format = @show_format
    @command.list_format = @list_format

    @contact.id = "jim"
  end

  describe "#name" do
    it "should be 'name'" do
      @command.name.should eq "name"
    end
  end

  describe "#execute" do

    it "should list all contact names if no contact ID is given" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process).and_return("all the names")
      @output.should_receive(:line).with("all the names")
      @input.arguments = []
      @command.execute(@input, @output)
    end

    it "should show the specified contact's name if no name is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("John Doe")
      @output.should_receive(:line).with("John Doe")
      @input.arguments = ["jim"]
      @command.execute(@input, @output)
    end

    it "should change the contact's name if a name is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:save_contact) do |contact|
        contact.name.should eq "Jim Jamieson"
      end
      @input.arguments = ["jim", "Jim Jamieson"]
      @command.execute(@input, @output)
    end

  end

end

