
describe Ppl::Command::Mutt do

  before(:each) do
    @command = Ppl::Command::Mutt.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)
    @format  = double(Ppl::Format::AddressBook)

    @address_book = Ppl::Entity::AddressBook.new
    @contact      = Ppl::Entity::Contact.new

    @command.storage = @storage
    @command.format = @format
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
      @input.arguments.push "query"
      @command.should_receive(:mutt_search).and_return(Ppl::Entity::AddressBook.new)
      @output.should_receive(:line).with("No matches")
      @command.execute(@input, @output).should eq false
    end

    it "should return email address matches" do

      @contact.name = "Test User"
      @contact.email_addresses.push "test@example.org"
      @address_book.contacts.push(@contact)

      @input.arguments.push "example"

      @storage.should_receive(:load_address_book).and_return(@address_book)
      @format.should_receive(:process).and_return("test@example.org\tTest User")
      @output.should_receive(:line) do |line|
        line.should include "Searching address book... 1 entries... 1 matching:"
        line.should include "test@example.org\tTest User"
      end
      @command.execute(@input, @output).should eq true
    end

    it "should only return matching email addresses" do
      @input.arguments.push "prova"
      @contact.name = "Test User"

      @contact.email_addresses.push "test@test.org"
      @contact.email_addresses.push "prova@prova.org"
      @address_book.contacts.push(@contact)
      @storage.stub(:load_address_book).and_return(@address_book)
      @format.should_receive(:process) do |address_book|
        address_book.contacts[0].email_addresses.length.should eq 1
        address_book.contacts[0].email_addresses[0].should eq "prova@prova.org"
      end
      @output.stub(:line)
      @command.execute(@input, @output)
    end

    it "should return name matches" do

      @contact.name = "Test User"
      @contact.email_addresses.push "test@example.org"
      @address_book.contacts.push(@contact)

      @input.arguments.push "User"

      @storage.should_receive(:load_address_book).and_return(@address_book)
      @format.should_receive(:process).and_return("test@example.org\tTest User")
      @output.should_receive(:line) do |line|
        line.should include "Searching address book... 1 entries... 1 matching:"
        line.should include "test@example.org\tTest User"
      end
      @command.execute(@input, @output).should eq true
    end


  end

end

