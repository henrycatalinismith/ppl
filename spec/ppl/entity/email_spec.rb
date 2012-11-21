
describe Ppl::Entity::Email do

  before(:each) do
    @email = Ppl::Entity::Email.new
  end

  describe "#address" do
    it "should return a value" do
      @email.address.should be nil
    end
  end

  describe "#location" do
    it "should return a value" do
      @email.location.should be nil
    end
  end

  describe "#preferred" do
    it "should return a boolean" do
      @email.preferred.should be false
    end
  end

end

