
describe Ppl::Command::Phone do

  before(:each) do
    @command = Ppl::Command::Phone.new
  end

  describe "#name" do
    it "should be 'phone'" do
      @command.name.should eq "phone"
    end
  end

  describe "#execute" do

    before(:each) do
      @contact = Ppl::Entity::Contact.new
      @storage = double(Ppl::Adapter::Storage)
      @input = Ppl::Application::Input.new
      @input.arguments = ["jdoe", "01234567"]
      @storage.stub(:require_contact).and_return(@contact)
      @storage.stub(:save_contact)
      @command.storage = @storage
    end

    it "should save phone numbers as instances of Ppl::Entity::PhoneNumber" do
      @storage.should_receive(:save_contact) do |c|
        c.phone_numbers.first.should be_a(Ppl::Entity::PhoneNumber)
      end
      @command.execute(@input, @output)
    end

    it "should save the given number as an attribute of the PhoneNumber" do
      @storage.should_receive(:save_contact) do |c|
        c.phone_numbers.first.number.should eq "01234567"
      end
      @command.execute(@input, @output)
    end

    it "should save the given type alongside the number" do
      @input.options[:type] = "cell"
      @storage.should_receive(:save_contact) do |c|
        c.phone_numbers.first.type.should eq "cell"
      end
      @command.execute(@input, @output)
    end

    it "shouldn't duplicate the number if the contact already has it" do
      @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("01234567")
      @storage.should_receive(:save_contact) do |c|
        c.phone_numbers.length.should eq 1
      end
      @command.execute(@input, @output)
    end

    it "should delete the given number from the contact" do
      @input.arguments = ["jdoe", "01234567"]
      @input.options[:delete] = "true"
      @contact.phone_numbers << Ppl::Entity::PhoneNumber.new("01234567")
      @storage.should_receive(:save_contact) do |c|
        c.phone_numbers.length.should eq 0
      end
      @command.execute(@input, @output)
    end

  end

end

