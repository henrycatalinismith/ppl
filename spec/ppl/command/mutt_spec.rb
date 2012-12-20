
describe Ppl::Command::Mutt do

  before(:each) do
    @command = Ppl::Command::Mutt.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)

    @address_book = Ppl::Entity::AddressBook.new
    @contact      = Ppl::Entity::Contact.new

    @command.storage = @storage
  end

  describe "#name" do
    it "should be 'mutt'" do
      @command.name.should eq "mutt"
    end
  end

  describe "#execute" do

    it "should raise an error if no query is given" do
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should search the address book for the query" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @input.arguments.push "query"
      @command.stub(:mutt_search) { |ab| [] }
      @output.should_receive(:line).with("No matches")
      @command.execute(@input, @output).should eq false
    end

    it "should return email address matches" do

      @contact.name = "Test User"
      @contact.email_address = "test@example.org"
      @address_book.add_contact(@contact)

      @input.arguments.push "example"

      @storage.should_receive(:load_address_book).and_return(@address_book)
      @output.should_receive(:line).with("Searching database... 1 entries... 1 matching:")
      @output.should_receive(:line).with("test@example.org\tTest User")
      @command.execute(@input, @output).should eq true
    end

    it "should return name matches" do

      @contact.name = "Test User"
      @contact.email_address = "test@example.org"
      @address_book.add_contact(@contact)

      @input.arguments.push "User"

      @storage.should_receive(:load_address_book).and_return(@address_book)
      @output.should_receive(:line).with("Searching database... 1 entries... 1 matching:")
      @output.should_receive(:line).with("test@example.org\tTest User")
      @command.execute(@input, @output).should eq true
    end


  end

end

