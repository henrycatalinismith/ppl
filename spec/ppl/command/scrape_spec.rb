
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

    it "should read input from ARGF" do
      @input.argf.should_receive(:read)
      @command.execute(@input, @output)
    end

  end

end

