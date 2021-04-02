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
      expect(@command.name).to eq "name"
    end
  end

  describe "#execute" do

    it "should list all contact names if no contact ID is given" do
      expect(@storage).to receive(:load_address_book).and_return(@address_book)
      expect(@list_format).to receive(:process).and_return("all the names")
      expect(@output).to receive(:line).with("all the names")
      @input.arguments = []
      @command.execute(@input, @output)
    end

    it "should show the specified contact's name if no name is given" do
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@show_format).to receive(:process).and_return("John Doe")
      expect(@output).to receive(:line).with("John Doe")
      @input.arguments = ["jim"]
      expect(@command.execute(@input, @output)).to eq true
    end

    it "should not output anything if there's nothing to show" do
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@show_format).to receive(:process).and_return("")
      @input.arguments = ["jim"]
      expect(@command.execute(@input, @output)).to eq false
    end

    it "should change the contact's name if a name is given" do
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@name_service).to receive(:update).with(@contact.name, {
        :full => "Jim Jamieson"
      })
      expect(@storage).to receive(:save_contact)
      @input.arguments = ["jim", "Jim Jamieson"]
      @command.execute(@input, @output)
    end

    it "should change the contact's name if a name is given" do
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@name_service).to receive(:update).with(@contact.name, {
        :family => "Smith"
      })
      expect(@storage).to receive(:save_contact)
      @input.arguments = ["jim"]
      @input.options = { :family => "Smith" }
      @command.execute(@input, @output)
    end

  end

end

