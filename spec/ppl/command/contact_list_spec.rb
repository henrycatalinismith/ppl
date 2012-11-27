
describe Ppl::Command::ContactList do

  before(:each) do
    @command = Ppl::Command::ContactList.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)
    @format  = double(Ppl::Format::AddressBook)
    @address_book = double(Ppl::Entity::AddressBook)

    @command.format   = @format
    @command.storage  = @storage
  end

  describe "#name" do
    it "should be 'ls'" do
      @command.name.should eq "ls"
    end
  end

  describe "#execute" do
    it "should show the list of contacts in the address book" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @format.should_receive(:process).and_return("list of contacts")
      @output.should_receive(:line).with("list of contacts")
      @command.execute(@input, @output)
    end
  end

end

