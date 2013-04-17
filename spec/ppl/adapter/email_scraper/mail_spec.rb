
describe Ppl::Adapter::EmailScraper::Mail do

  before(:each) do
    @adapter = Ppl::Adapter::EmailScraper::Mail.new
  end

  describe "#scrape_contacts" do

    it "should return an array" do
      @adapter.scrape_contacts("").should eq []
    end

  end

end

