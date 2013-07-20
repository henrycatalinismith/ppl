
describe Ppl::Command::Name do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::Name.new

    @address_book = Ppl::Entity::AddressBook.new

    @storage      = double(Ppl::Adapter::Storage)
    @show_format  = double(Ppl::Format::Contact)
    @list_format  = double(Ppl::Format::Contact)
    @name_service = double(Ppl::Service::Name)

    @command.storage      = @storage
    @command.show_format  = @show_format
    @command.list_format  = @list_format
    @command.name_service = @name_service

    @contact.id = "jim"
    @contact.name = Ppl::Entity::Name.new
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
      @command.execute(@input, @output).should eq true
    end

    it "should not output anything if there's nothing to show" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("")
      @input.arguments = ["jim"]
      @command.execute(@input, @output).should eq false
    end

    it "should change the contact's name if a name is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @name_service.should_receive(:update).with(@contact.name, {
        :full => "Jim Jamieson"
      })
      @storage.should_receive(:save_contact)
      @input.arguments = ["jim", "Jim Jamieson"]
      @command.execute(@input, @output)
    end

    it "should change the contact's name if a name is given" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @name_service.should_receive(:update).with(@contact.name, {
        :family => "Smith"
      })
      @storage.should_receive(:save_contact)
      @input.arguments = ["jim"]
      @input.options = { :family => "Smith" }
      @command.execute(@input, @output)
    end

  end

end

