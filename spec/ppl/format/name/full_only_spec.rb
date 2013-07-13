
describe Ppl::Format::Name::FullOnly do

  before(:each) do
    @format = Ppl::Format::Name::FullOnly.new
    @name   = Ppl::Entity::Name.new
  end

  describe "#process" do

    it "should return just the full name" do
      @name.full = "John Doe"
      @format.process(@name).should eq "John Doe"
    end

  end

end

