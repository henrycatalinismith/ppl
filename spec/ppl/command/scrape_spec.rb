describe Ppl::Command::Scrape do

  before(:each) do
    @command = Ppl::Command::Scrape.new
    @input   = Ppl::Application::Input.new
    @input.stdin = double(IO)
    @contact = Ppl::Entity::Contact.new
    @output  = double(Ppl::Application::Output)
    @email_scraper = double(Ppl::Adapter::EmailScraper)
    @storage = double(Ppl::Adapter::Storage)
    @address_book = double(Ppl::Entity::AddressBook)
    @command.storage = @storage
    @command.email_scraper = @email_scraper
  end

  describe "#name" do
    it "should be 'scrape'" do
      expect(@command.name).to eq "scrape"
    end
  end

  describe "#execute" do

    before(:each) do
      allow(@input.stdin).to receive(:read)
      allow(@input.stdin).to receive(:reopen)
      allow(@input.stdin).to receive(:eof?)
      allow(@email_scraper).to receive(:scrape_contacts).and_return([])
      allow(Readline).to receive(:readline).and_return("")
      allow(@storage).to receive(:save_contact)
    end

    it "should read input from stdin" do
      @input.options[:sender] = true
      expect(@input.stdin).to receive(:read)
      @command.execute(@input, @output)
    end

    it "should pass input to the email scraper" do
      @input.options[:sender] = true
      expect(@email_scraper).to receive(:scrape_contacts)
      @command.execute(@input, @output)
    end

    it "shouldn't do any scraping unless told which fields to scrape" do
      expect(@email_scraper).not_to receive(:scrape_contacts)
      @command.execute(@input, @output)
    end

    it "should always save contacts if in quiet mode" do
      @input.options[:sender] = true
      @input.options[:quiet] = true
      allow(@email_scraper).to receive(:scrape_contacts).and_return([@contact])
      expect(Readline).not_to receive(:readline)
      expect(@storage).to receive(:save_contact)
      @command.execute(@input, @output)
    end

    it "should reopen stdin to prompt the user" do
      @input.options[:sender] = true
      expect(@input.stdin).to receive(:eof?).and_return(true)
      expect(@input.stdin).to receive(:reopen)
      allow(@email_scraper).to receive(:scrape_contacts).and_return([@contact])
      @command.execute(@input, @output)
    end

    it "should save the contact if the user approves" do
      @input.options[:sender] = true
      allow(@email_scraper).to receive(:scrape_contacts).and_return([@contact])
      expect(Readline).to receive(:readline).and_return("y")
      expect(@storage).to receive(:save_contact)
      @command.execute(@input, @output)
    end

    it "should not save the contact if the user disapproves" do
      @input.options[:sender] = true
      allow(@email_scraper).to receive(:scrape_contacts).and_return([@contact])
      expect(Readline).to receive(:readline).and_return("n")
      expect(@storage).not_to receive(:save_contact)
      @command.execute(@input, @output)
    end

    it "should prompt the user with the contact's name and email address" do
      @input.options[:sender] = true
      contact = Ppl::Entity::Contact.new
      contact.name = "Test Person"
      contact.email_addresses << "test@example.org"
      allow(@email_scraper).to receive(:scrape_contacts).and_return([contact])
      expect(Readline).to receive(:readline).with("Add \"Test Person <test@example.org>\" to your address book [Y/n]? ")
      @command.execute(@input, @output)
    end

  end

end

