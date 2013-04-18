
describe Ppl::Command::Scrape do

  before(:each) do
    @command = Ppl::Command::Scrape.new
    @input   = Ppl::Application::Input.new
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
      @input.argf.stub(:read)
      @email_scraper.stub(:scrape_contacts).and_return([])
      Readline.stub(:readline)
      @storage.stub(:save_contact)
    end

    it "should read input from ARGF" do
      @input.options[:sender] = true
      @input.argf.should_receive(:read)
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
      @email_scraper.stub(:scrape_contacts).and_return([1, 2, 3])
      Readline.should_not_receive(:readline)
      @storage.should_receive(:save_contact).exactly(3).times
      @command.execute(@input, @output)
    end

    it "should save the contact if the user approves" do
      @input.options[:sender] = true
      @email_scraper.stub(:scrape_contacts).and_return([1, 2, 3])
      Readline.should_receive(:readline).exactly(3).times.and_return("y")
      @storage.should_receive(:save_contact).exactly(3).times
      @command.execute(@input, @output)
    end

    it "should not save the contact if the user disapproves" do
      @input.options[:sender] = true
      @email_scraper.stub(:scrape_contacts).and_return([1, 2, 3])
      Readline.should_receive(:readline).exactly(3).times.and_return("n")
      @storage.should_not_receive(:save_contact)
      @command.execute(@input, @output)
    end

  end

end

