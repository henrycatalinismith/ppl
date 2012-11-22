
describe Ppl::Command::ContactDelete do

  before(:each) do
    @input   = Ppl::Application::Input.new
    @output  = Ppl::Application::Output.new(nil, nil)
    @contact = Ppl::Entity::Contact.new
    @command = Ppl::Command::ContactDelete.new
    @storage = double(Ppl::Adapter::Storage)

    @command.storage = @storage
  end

  describe "#name" do
    it "should be 'rm'" do
      @command.name.should eq "rm"
    end
  end

  describe "#execute" do

    it "should delete the given contact" do
      @storage.should_receive(:require_contact).and_return(@contact)
      @storage.should_receive(:delete_contact).with(@contact)
      @command.execute(@input, @output)
    end

  end

end

