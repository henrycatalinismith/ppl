
describe Ppl::Entity::PhoneNumber do

  before(:each) do
    @phone_number = Ppl::Entity::PhoneNumber.new
  end

  describe "#number" do
    it "should return a value" do
      @phone_number.number.should eq nil
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
  end

end

