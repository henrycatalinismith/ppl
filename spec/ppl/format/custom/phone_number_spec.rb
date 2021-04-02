describe Ppl::Format::Custom::PhoneNumber do

  before(:each) do
    @format = Ppl::Format::Custom::PhoneNumber.new
    @number = Ppl::Entity::PhoneNumber.new
  end

  describe "%n" do
    it "should output the number itself" do
      @number.number = "1234567890"
      @format.format = "tel: %n"
      expect(@format.process(@number)).to eq "tel: 1234567890"
    end
  end

  describe "%t" do
    it "should output the type of the number" do
      @number.type = "cell"
      @format.format = "(%t)"
      expect(@format.process(@number)).to eq "(cell)"
    end
  end

  describe "%f" do
    before(:each) do
      @format.format = "%f"
    end
    it "should output a star if the number is preferred" do
      @number.preferred = true
      expect(@format.process(@number)).to eq "*"
    end
    it "should output nothing if the number is not preferred" do
      @number.preferred = false
      expect(@format.process(@number)).to eq ""
    end
  end

end


