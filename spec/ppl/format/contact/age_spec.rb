
describe Ppl::Format::Contact::Age do

  before(:each) do
    @format  = Ppl::Format::Contact::Age.new
    @contact = double(Ppl::Entity::Contact)
  end

  describe "#process" do

    it "should return an empty string if the contact lacks a birth date" do
      @contact.should_receive(:age).and_return(nil)
      @format.process(@contact).should eq ""
    end

    it "should return the contact's age if the birthdate is known" do
      @contact.should_receive(:age).and_return(10)
      @format.process(@contact).should eq "10"
    end

  end

end

