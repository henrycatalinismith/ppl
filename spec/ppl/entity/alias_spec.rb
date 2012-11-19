
describe Ppl::Entity::Alias, "#initialize" do

  it "should accept a name" do
    @alias = Ppl::Entity::Alias.new("l", nil)
    @alias.name.should eq "l"
  end

  it "should accept a value" do
    @alias = Ppl::Entity::Alias.new(nil, "list")
    @alias.value.should eq "list"
  end

end
