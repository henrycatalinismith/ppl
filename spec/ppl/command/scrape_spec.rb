
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
      @command.name.should eq "scrape"
    end
  end

  describe "#execute" do

    before(:each) do
      @input.stdin.stub(:read)
      @input.stdin.stub(:reopen)
      @input.stdin.stub(:eof?)
      @email_scraper.stub(:scrape_contacts).and_return([])
      Readline.stub(:readline)
      @storage.stub(:save_contact)
    end

    it "should read input from stdin" do
      @input.options[:sender] = true
      @input.stdin.should_receive(:read)
      @command.execute(@input, @output)
    end

    it "should pass input to the email scraper" do
      @input.options[:sender] = true
      @email_scraper.should_receive(:scrape_contacts)
      @command.execute(@input, @output)
    end

    it "shouldn't do any scraping unless told which fields to scrape" do
      @email_scraper.should_not_receive(:scrape_contacts)
      @command.execute(@input, @output)
    end

    it "should always save contacts if in quiet mode" do
      @input.options[:sender] = true
      @input.options[:quiet] = true
      @email_scraper.stub(:scrape_contacts).and_return([@contact])
      Readline.should_not_receive(:readline)
      @storage.should_receive(:save_contact)
      @command.execute(@input, @output)
    end

    it "should reopen stdin to prompt the user" do
      @input.options[:sender] = true
      @input.stdin.should_receive(:eof?).and_return(true)
      @input.stdin.should_receive(:reopen)
      @email_scraper.stub(:scrape_contacts).and_return([@contact])
      @command.execute(@input, @output)
    end

    it "should save the contact if the user approves" do
      @input.options[:sender] = true
      @email_scraper.stub(:scrape_contacts).and_return([@contact])
      Readline.should_receive(:readline).and_return("y")
      @storage.should_receive(:save_contact)
      @command.execute(@input, @output)
    end

    it "should not save the contact if the user disapproves" do
      @input.options[:sender] = true
      @email_scraper.stub(:scrape_contacts).and_return([@contact])
      Readline.should_receive(:readline).and_return("n")
      @storage.should_not_receive(:save_contact)
      @command.execute(@input, @output)
    end

    it "should prompt the user with the contact's name and email address" do
      @input.options[:sender] = true
      contact = Ppl::Entity::Contact.new
      contact.name = "Test Person"
      contact.email_addresses << "test@example.org"
      @email_scraper.stub(:scrape_contacts).and_return([contact])
      Readline.should_receive(:readline).with("Add \"Test Person <test@example.org>\" to your address book [Y/n]? ")
      @command.execute(@input, @output)
    end

  end

end

