
describe Ppl::Entity::PhoneNumber do

  before(:each) do
    @phone_number = Ppl::Entity::PhoneNumber.new
  end

  describe "#number" do
    it "should return a value" do
      @phone_number.number.should eq nil
    end
  end

  describe "#preferred" do
    it "should be false by default" do
      @phone_number.preferred.should eq false
    end
  end

  describe "#type" do
    it "should return a value" do
      @phone_number.type.should eq nil
    end
  end

  describe "#initialize" do
    it "should accept a number" do
      phone = Ppl::Entity::PhoneNumber.new(12345)
      phone.number.should eq 12345
    end
    it "should accept a type" do
      phone = Ppl::Entity::PhoneNumber.new(nil, "cell")
      phone.type.should eq "cell"
    end
  end

end

