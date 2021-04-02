describe Ppl::Format::PostalAddress::MultiLine do

  before(:each) do
    @format  = Ppl::Format::PostalAddress::MultiLine.new
    @address = Ppl::Entity::PostalAddress.new
  end

  describe "#process" do

    context "all address attributes contain a value" do

      before(:each) do
        @address.id = "home"
        @address.street = "123 Happy Lane"
        @address.country = "United Kingdom"
        @address.locality = "Bristol"
        @address.po_box = "12345"
        @address.postal_code = "BS1 1SB"
        @address.region = "A very nice region indeed"
      end

      it "outputs each address attribute on its own line" do
        @lines = @format.process(@address).split "\n"
        expect(@lines[0]).to eq "123 Happy Lane"
        expect(@lines[1]).to eq "Bristol"
        expect(@lines[2]).to eq "A very nice region indeed"
        expect(@lines[3]).to eq "United Kingdom"
        expect(@lines[4]).to eq "12345"
        expect(@lines[5]).to eq "BS1 1SB"
      end

    end

    context "some empty address attributes" do

      before(:each) do
        @address.id = "home"
        @address.street = "123 Happy Lane"
        @address.country = "United Kingdom"
        @address.locality = "Bristol"
      end

      it "doesn't output superfluous blank lines" do
        @lines = @format.process(@address).split "\n"
        expect(@lines.length).to eq 3
        expect(@lines[0]).to eq "123 Happy Lane"
        expect(@lines[1]).to eq "Bristol"
        expect(@lines[2]).to eq "United Kingdom"
      end

    end

  end

end

