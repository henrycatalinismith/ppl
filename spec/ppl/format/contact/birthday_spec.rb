describe Ppl::Format::Contact::Birthday do

  before(:each) do
    @format  = Ppl::Format::Contact::Birthday.new
    @contact = Ppl::Entity::Contact.new
    @color   = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a birthday" do
      expect(@format.process(Ppl::Entity::Contact.new)).to eq ""
    end

    it "should return the contact's birthday if it is set" do
      @contact.birthday = Date.parse("1970-01-01")
      expect(@format.process(@contact)).to eq "1970-01-01"
    end

    it "should colorize the string if configured to do so" do
      @format.colors = { "birthday" => "blue" }
      expect(@color).to receive(:colorize).and_return("birthday in blue")
      expect(@format.process(@contact)).to eq "birthday in blue"
    end

  end

end

