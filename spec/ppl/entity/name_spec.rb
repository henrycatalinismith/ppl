describe Ppl::Entity::Name do

  before(:each) do
    @name = Ppl::Entity::Name.new
  end

  describe "#to_s" do
    it "returns the full name" do
      @name.full = "Mr. Testing"
      expect(@name.to_s).to eq "Mr. Testing"
    end
  end

end

