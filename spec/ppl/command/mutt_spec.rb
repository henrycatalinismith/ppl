
describe Ppl::Command::Mutt do

  before(:each) do
    @command = Ppl::Command::Mutt.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)
    @format  = double(Ppl::Format::AddressBook)

    @address_book = Ppl::Entity::AddressBook.new
    @contact      = Ppl::Entity::Contact.new
    @contact.name = Ppl::Entity::Name.new

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

      @contact.name.full = "Test User"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("test@example.org")
      @address_book.contacts.push(@contact)

      @input.arguments.push "example"

      @storage.should_receive(:load_address_book).and_return(@address_book)
      @format.should_receive(:process).and_return("test@example.org\tTest User")
      @output.should_receive(:line) do |line|
        line.should include "Searching address book... 1 email addresses... 1 matching:"
        line.should include "test@example.org\tTest User"
      end
      @command.execute(@input, @output).should eq true
    end

    it "should only return matching email addresses" do
      @input.arguments.push "prova"
      @contact.name.full = "Test User"

      @contact.email_addresses << Ppl::Entity::EmailAddress.new("test@test.org")
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("prova@prova.org")
      @address_book.contacts.push(@contact)
      @storage.stub(:load_address_book).and_return(@address_book)
      @format.should_receive(:process) do |address_book|
        address_book.contacts[0].email_addresses.length.should eq 1
        address_book.contacts[0].email_addresses[0].address.should eq "prova@prova.org"
      end
      @output.stub(:line)
      @command.execute(@input, @output)
    end

    it "should return name matches" do

      @contact.name.full = "Test User"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("test@example.org")
      @address_book.contacts.push(@contact)

      @input.arguments.push "User"

      @storage.should_receive(:load_address_book).and_return(@address_book)
      @format.should_receive(:process).and_return("test@example.org\tTest User")
      @output.should_receive(:line) do |line|
        line.should include "Searching address book... 1 email addresses... 1 matching:"
        line.should include "test@example.org\tTest User"
      end
      @command.execute(@input, @output).should eq true
    end


    it "should count up email addresses in the status line" do
      @input.arguments.push "org"

      @contact.name.full = "Test User"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("test@test.org")
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("prova@prova.org")
      @address_book.contacts << @contact

      @storage.stub(:load_address_book).and_return(@address_book)
      @format.stub(:process)
      @output.stub(:line)
      @output.should_receive(:line) do |line|
        line.should include "Searching address book... 2 email addresses... 2 matching:"
      end
      @command.execute(@input, @output)
    end

  end

  describe "#execute (case-insensitive)" do

    before(:each) do
      @input.options[:ignore_case] = true
      @contact.name.full = "Joe Schmoe"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("joe@somewhere.com")
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("LOUD@SHOUTING.COM")
      @address_book.contacts << @contact
      @storage.stub(:load_address_book).and_return(@address_book)
      @output.stub(:line)
    end

    it "should ignore case when matching names" do
      @input.arguments.push "joe schmoe"
      @format.should_receive(:process) do |address_book|
        address_book.contacts[0].email_addresses.length.should eq 2
      end
      @command.execute(@input, @output)
    end

    it "should ignore case when matching email addresses" do
      @input.arguments.push "loud"
      @format.should_receive(:process) do |address_book|
        address_book.contacts[0].email_addresses.length.should eq 1
        address_book.contacts[0].email_addresses[0].address.should eq "LOUD@SHOUTING.COM"
      end
      @command.execute(@input, @output)
    end

  end

end

