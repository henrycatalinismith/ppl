
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
        @lines[0].should eq "123 Happy Lane"
        @lines[1].should eq "Bristol"
        @lines[2].should eq "A very nice region indeed"
        @lines[3].should eq "United Kingdom"
        @lines[4].should eq "12345"
        @lines[5].should eq "BS1 1SB"
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
        @lines.length.should eq 3
        @lines[0].should eq "123 Happy Lane"
        @lines[1].should eq "Bristol"
        @lines[2].should eq "United Kingdom"
      end

    end

  end

end

