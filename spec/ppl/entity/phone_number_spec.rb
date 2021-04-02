describe Ppl::Entity::PhoneNumber do

  before(:each) do
    @phone_number = Ppl::Entity::PhoneNumber.new
  end

  describe "#number" do
    it "should return a value" do
      expect(@phone_number.number).to eq nil
    end
  end

  describe "#preferred" do
    it "should be false by default" do
      expect(@phone_number.preferred).to eq false
    end
  end

  describe "#type" do
    it "should return a value" do
      expect(@phone_number.type).to eq nil
    end
  end

  describe "#initialize" do
    it "should accept a number" do
      phone = Ppl::Entity::PhoneNumber.new(12345)
      expect(phone.number).to eq 12345
    end
    it "should accept a type" do
      phone = Ppl::Entity::PhoneNumber.new(nil, "cell")
      expect(phone.type).to eq "cell"
    end
  end

end

