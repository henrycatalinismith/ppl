describe Ppl::Format::Contact::Age do

  before(:each) do
    @format  = Ppl::Format::Contact::Age.new
    @contact = double(Ppl::Entity::Contact)
    @color   = double(Ppl::Adapter::Color)
    @format.color_adapter = @color
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a birth date" do
      allow(@color).to receive(:colorize)
      expect(@contact).to receive(:age).and_return(nil)
      expect(@format.process(@contact)).to eq ""
    end

    it "should return the contact's age if the birthdate is known" do
      expect(@contact).to receive(:age).and_return(10)
      expect(@format.process(@contact)).to eq "10"
    end

    it "should colorize the string if configured to do so" do
      expect(@contact).to receive(:age).and_return(10)
      @format.colors = { "age" => "blue" }
      expect(@color).to receive(:colorize).and_return("age in blue")
      expect(@format.process(@contact)).to eq "age in blue"
    end

  end

end

