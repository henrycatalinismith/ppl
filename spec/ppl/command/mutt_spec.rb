
describe Ppl::Command::Mutt do

  before(:each) do
    @command = Ppl::Command::Mutt.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)

    @address_book = Ppl::Entity::AddressBook.new

    @command.storage = @storage
  end

  describe "#name" do
    it "should be 'mutt'" do
      @command.name.should eq "mutt"
    end
  end

  describe "#execute" do
    it "should search the address book for the query" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @command.stub(:mutt_search) { |ab| [] }

      @output.should_receive(:line).with("Searching database... 0 entries... 0 matching:")

      @command.execute(@input, @output)
    end
  end

end

