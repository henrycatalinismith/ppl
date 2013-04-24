
describe Ppl::Format::Custom::EmailAddress do

  before(:each) do
    @format = Ppl::Format::Custom::EmailAddress.new
    @address = Ppl::Entity::EmailAddress.new
  end

  describe "%a" do
    it "should output the address" do
      @address.address = "test@example.org"
      @format.format = "<%a>"
      @format.process(@address).should eq "<test@example.org>"
    end
  end

end


