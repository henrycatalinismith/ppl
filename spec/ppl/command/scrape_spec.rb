
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
    end

    it "should read input from ARGF" do
      @input.argf.should_receive(:read)
      @command.execute(@input, @output)
    end

    it "should pass input to the email scraper" do
      @email_scraper.should_receive(:scrape_contacts)
      @command.execute(@input, @output)
    end

    it "should save all contacts returned by the scraper" do
      @email_scraper.stub(:scrape_contacts).and_return([1, 2, 3])
      @storage.should_receive(:save_contact).exactly(3).times
      @command.execute(@input, @output)
    end

  end

end

