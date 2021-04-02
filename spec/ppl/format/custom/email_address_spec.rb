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

  describe "%f" do
    before(:each) do
      @format.format = "%f"
    end
    it "should output a star if the address is preferred" do
      @address.preferred = true
      @format.process(@address).should eq "*"
    end
    it "should output nothing if the address is not preferred" do
      @address.preferred = false
      @format.process(@address).should eq ""
    end
  end

end


