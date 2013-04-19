
describe Ppl::Adapter::EmailScraper do

  before(:each) do
    @adapter = Ppl::Adapter::EmailScraper.new
  end

  describe "#scrape_contacts" do
    it "should raise not implemented error" do
      expect{@adapter.scrape_contacts("")}.to raise_error(NotImplementedError)
    end
  end

end

