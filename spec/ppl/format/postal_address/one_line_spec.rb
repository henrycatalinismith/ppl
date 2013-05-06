
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
      @table.should_receive(:add_row) { |r| r[:star].should eq " " }
    end

    it "puts the ID in its own column" do
      @table.should_receive(:add_row) { |r| r[:address_id].should eq "home" }
    end

    it "concatenates the rest of the address in its own column" do
      @address.country = nil
      @table.should_receive(:add_row) do |row|
        row[:address_text].should eq "123 Happy Lane"
      end
    end

    it "separates address elements with commas" do
      @table.should_receive(:add_row) do |row|
        row[:address_text].should eq "123 Happy Lane, United Kingdom"
      end
    end

    it "prunes elements that are empty" do
      @address.country = ""
      @table.should_receive(:add_row) do |row|
        row[:address_text].should eq "123 Happy Lane"
      end
    end

  end

end

