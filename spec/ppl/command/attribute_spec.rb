
describe Ppl::Command::Attribute do

  before(:each) do
    @command = Ppl::Command::Attribute.new
    @input = Ppl::Application::Input.new
    @output = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)
    @list_format = double(Ppl::Format::AddressBook)
    @show_format = double(Ppl::Format::Contact)
    @address_book = double(Ppl::Entity::AddressBook)
    @contact = double(Ppl::Entity::Contact)

    @command.list_format = @list_format
    @command.show_format = @show_format
    @command.storage = @storage
  end


  describe "#list_attribute" do

    it "should list all the contacts and the value of the attribute for each" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process).and_return("imagine this is a list")
      @output.should_receive(:line).with("imagine this is a list")
      @command.execute(@input, @output).should eq true
    end

  end

  describe "#show_attribute" do

    it "should show the full list of attributes for the given contact" do
      @input.arguments.push("jdoe")
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("all the info")
      @output.should_receive(:line).with("all the info")
      @command.execute(@input, @output).should eq true
    end

  end

end

