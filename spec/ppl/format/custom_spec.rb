describe "Ppl::Format::Custom" do

  describe "::format" do
    it "should accept a symbol and a block" do
      Ppl::Format::Custom::format :N do |h| h[:name] end
    end
  end

  describe "::process" do
    it "should use the block passed to ::format to process the object" do
      expect(Ppl::Format::Custom::process(:N, {:name => "jdoe"})).to eq "jdoe"
    end
  end

  describe "#initialize" do
    it "should accept a format string" do
      expect(Ppl::Format::Custom.new("%N").format).to eq "%N"
    end
  end

  describe "#process" do
    it "should convert the given object into a string based on the format" do
      custom = Ppl::Format::Custom.new("%N %N %N")
      object = { :name => "jdoe" }
      expect(custom.process(object)).to eq "jdoe jdoe jdoe"
    end
    it "should pad with leading spaces if a positive width is given" do
      custom = Ppl::Format::Custom.new("%10N")
      object = { :name => "jdoe" }
      expect(custom.process(object)).to eq "      jdoe"
    end
    it "should pad with trailing spaces if a negative width is given" do
      custom = Ppl::Format::Custom.new("%-10N")
      object = { :name => "jdoe" }
      expect(custom.process(object)).to eq "jdoe      "
    end
  end

  describe "#use_preset" do
    it "should set the format string to the preset with the given name" do
      custom = Ppl::Format::Custom.new
      custom.preset_formats = { "example" => "%N (%N)" }
      custom.use_preset "example"
      expect(custom.process({:name => "a"})).to eq "a (a)"
    end
  end

end

