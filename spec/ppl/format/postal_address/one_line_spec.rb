describe Ppl::Format::PostalAddress::OneLine do

  before(:each) do
    @format  = Ppl::Format::PostalAddress::OneLine.new
    @table   = double(Ppl::Format::Table)
    @address = Ppl::Entity::PostalAddress.new
  end

  describe "#process" do

    before(:each) do
      @address.id = "home"
      @address.street = "123 Happy Lane"
      @address.country = "United Kingdom"
    end

    after(:each) do
      @format.process(@address, @table)
    end

    it "inserts a blank 'star' column" do
      expect(@table).to receive(:add_row) { |r| expect(r[:star]).to eq " " }
    end

    it "marks preferred addresses with a star" do
      @address.preferred = true
      expect(@table).to receive(:add_row) { |r| expect(r[:star]).to eq "*" }
    end

    it "puts the ID in its own column" do
      expect(@table).to receive(:add_row) { |r| expect(r[:address_id]).to eq "home" }
    end

    it "concatenates the rest of the address in its own column" do
      @address.country = nil
      expect(@table).to receive(:add_row) do |row|
        expect(row[:address_text]).to eq "123 Happy Lane"
      end
    end

    it "separates address elements with commas" do
      expect(@table).to receive(:add_row) do |row|
        expect(row[:address_text]).to eq "123 Happy Lane, United Kingdom"
      end
    end

    it "prunes elements that are empty" do
      @address.country = ""
      expect(@table).to receive(:add_row) do |row|
        expect(row[:address_text]).to eq "123 Happy Lane"
      end
    end

  end

end

