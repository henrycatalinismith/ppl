
describe "Ppl::Format::Custom" do

  describe "::format" do
    it "should accept a symbol and a block" do
      Ppl::Format::Custom::format :n do |h| h[:name] end
    end
  end

  describe "::process" do
    it "should use the block passed to ::format to process the object" do
      Ppl::Format::Custom::process(:n, {:name => "jdoe"}).should eq "jdoe"
    end
  end

  describe "#initialize" do
    it "should accept a format string" do
      Ppl::Format::Custom.new("%n").format.should eq "%n"
    end
  end

  describe "#process" do
    it "should convert the given object into a string based on the format" do
      custom = Ppl::Format::Custom.new("%n %n %n")
      object = { :name => "jdoe" }
      custom.process(object).should eq "jdoe jdoe jdoe"
    end
    it "should pad with leading spaces if a positive width is given" do
      custom = Ppl::Format::Custom.new("%10n")
      object = { :name => "jdoe" }
      custom.process(object).should eq "      jdoe"
    end
    it "should pad with trailing spaces if a negative width is given" do
      custom = Ppl::Format::Custom.new("%-10n")
      object = { :name => "jdoe" }
      custom.process(object).should eq "jdoe      "
    end
  end

end

