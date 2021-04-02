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
      expect(@command.name).to eq "mutt"
    end
  end

  describe "#execute" do

    it "should raise an error if no query is given" do
      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::IncorrectUsage)
    end

    it "should search the address book for the query" do
      @input.arguments.push "query"
      expect(@command).to receive(:mutt_search).and_return(Ppl::Entity::AddressBook.new)
      expect(@output).to receive(:line).with("No matches")
      expect(@command.execute(@input, @output)).to eq false
    end

    it "should return email address matches" do

      @contact.name.full = "Test User"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("test@example.org")
      @address_book.contacts.push(@contact)

      @input.arguments.push "example"

      expect(@storage).to receive(:load_address_book).and_return(@address_book)
      expect(@format).to receive(:process).and_return("test@example.org\tTest User")
      expect(@output).to receive(:line) do |line|
        expect(line).to include "Searching address book... 1 email addresses... 1 matching:"
        expect(line).to include "test@example.org\tTest User"
      end
      expect(@command.execute(@input, @output)).to eq true
    end

    it "should only return matching email addresses" do
      @input.arguments.push "prova"
      @contact.name.full = "Test User"

      @contact.email_addresses << Ppl::Entity::EmailAddress.new("test@test.org")
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("prova@prova.org")
      @address_book.contacts.push(@contact)
      allow(@storage).to receive(:load_address_book).and_return(@address_book)
      expect(@format).to receive(:process) do |address_book|
        expect(address_book.contacts[0].email_addresses.length).to eq 1
        expect(address_book.contacts[0].email_addresses[0].address).to eq "prova@prova.org"
      end
      allow(@output).to receive(:line)
      @command.execute(@input, @output)
    end

    it "should return name matches" do

      @contact.name.full = "Test User"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("test@example.org")
      @address_book.contacts.push(@contact)

      @input.arguments.push "User"

      expect(@storage).to receive(:load_address_book).and_return(@address_book)
      expect(@format).to receive(:process).and_return("test@example.org\tTest User")
      expect(@output).to receive(:line) do |line|
        expect(line).to include "Searching address book... 1 email addresses... 1 matching:"
        expect(line).to include "test@example.org\tTest User"
      end
      expect(@command.execute(@input, @output)).to eq true
    end


    it "should count up email addresses in the status line" do
      @input.arguments.push "org"

      @contact.name.full = "Test User"
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("test@test.org")
      @contact.email_addresses << Ppl::Entity::EmailAddress.new("prova@prova.org")
      @address_book.contacts << @contact

      allow(@storage).to receive(:load_address_book).and_return(@address_book)
      allow(@format).to receive(:process)
      allow(@output).to receive(:line)
      expect(@output).to receive(:line) do |line|
        expect(line).to include "Searching address book... 2 email addresses... 2 matching:"
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
      allow(@storage).to receive(:load_address_book).and_return(@address_book)
      allow(@output).to receive(:line)
    end

    it "should ignore case when matching names" do
      @input.arguments.push "joe schmoe"
      expect(@format).to receive(:process) do |address_book|
        expect(address_book.contacts[0].email_addresses.length).to eq 2
      end
      @command.execute(@input, @output)
    end

    it "should ignore case when matching email addresses" do
      @input.arguments.push "loud"
      expect(@format).to receive(:process) do |address_book|
        expect(address_book.contacts[0].email_addresses.length).to eq 1
        expect(address_book.contacts[0].email_addresses[0].address).to eq "LOUD@SHOUTING.COM"
      end
      @command.execute(@input, @output)
    end

  end

end

