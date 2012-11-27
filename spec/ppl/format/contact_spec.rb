
describe Ppl::Format::Contact do

  before(:each) do
    @format = Ppl::Format::Contact.new
  end

  describe "#process" do

    it "should raise a NotImplementedError" do
      expect{@format.process(nil)}.to raise_error(NotImplementedError)
    end

  end

end

