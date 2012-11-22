
describe Ppl::Command::ContactDelete do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @command = Ppl::Command::ContactDelete.new
    @storage = double(Ppl::Adapter::Storage)

    @command.storage = @storage
  end

  describe "#name" do
    it "should be 'rm'" do
      @command.name.should eq "rm"
    end
  end

  describe "#name" do
    it "should throw a Ppl::Error::ContactNotFound for invalid contacts" do
      @storage.should_receive(:load_contact).and_return(nil)

      @input.arguments.push("nobody")

      expect{@command.execute(@input, @output)}.to raise_error(Ppl::Error::ContactNotFound)
    end
  end

end

