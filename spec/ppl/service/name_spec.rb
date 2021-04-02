describe Ppl::Service::Name do

  before(:each) do
    @service = Ppl::Service::Name.new
    @name = Ppl::Entity::Name.new
  end

  describe "#parse" do

    it "uses the whole string for the full name" do
      @service.parse("John Smith").full.should eq "John Smith"
    end

    it "uses the first word for the given name" do
      @service.parse("John Smith").given.should eq "John"
    end

    it "uses the rest of the string for the family names" do
      @service.parse("John Fitzgerald Donald Smith").family.should eq "Fitzgerald Donald Smith"
    end

  end

  describe "#update" do

    it "updates the full name" do
      @service.update(@name, {:full => "Abc Def"})
      @name.full.should eq "Abc Def"
    end

    it "updates the given names" do
      @service.update(@name, {:given => "John"})
      @name.given.should eq "John"
    end

    it "updates the family names" do
      @service.update(@name, {:family => "Smith"})
      @name.family.should eq "Smith"
    end

    it "updates the middle names" do
      @service.update(@name, {:middle => "Arnold"})
      @name.middle.should eq "Arnold"
    end

    it "updates the name prefix" do
      @service.update(@name, {:prefix => "Mr"})
      @name.prefix.should eq "Mr"
    end

    it "updates the name suffix" do
      @service.update(@name, {:suffix => "BSc"})
      @name.suffix.should eq "BSc"
    end

  end

end

