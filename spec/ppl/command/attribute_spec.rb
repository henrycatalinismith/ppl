describe Ppl::Command::Attribute do

  before(:each) do
    @attribute = :phone_numbers
    @command = Ppl::Command::Attribute.new
    @input = Ppl::Application::Input.new
    @output = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)
    @list_format = double(Ppl::Format::AddressBook)
    @show_format = double(Ppl::Format::Contact)
    @address_book = double(Ppl::Entity::AddressBook)
    @contact = double(Ppl::Entity::Contact)

    @command.attribute = @attribute
    @command.list_format = @list_format
    @command.show_format = @show_format
    @command.storage = @storage
  end


  describe "#execute" do

    it "should list all the contacts and the value of the attribute for each" do
      @storage.should_receive(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:process).and_return("imagine this is a list")
      @output.should_receive(:line).with("imagine this is a list")
      @command.execute(@input, @output).should eq true
    end

    it "should disable color output if :no_color is set" do
      @input.options[:no_color] = true
      @storage.stub(:load_address_book).and_return(@address_book)
      @list_format.should_receive(:disable_colors!)
      @list_format.stub(:process)
      @output.should_receive(:line)
      @command.execute(@input, @output).should eq true
    end

    it "should show the full list of attributes for the given contact" do
      @input.arguments.push("jdoe")
      @storage.should_receive(:require_contact).and_return(@contact)
      @show_format.should_receive(:process).and_return("all the info")
      @output.should_receive(:line).with("all the info")
      @command.execute(@input, @output).should eq true
    end

    it "should add the given value to the contact's attributes" do
      @input.arguments.push("jdoe", "anyvalue")
      @storage.should_receive(:require_contact).and_return(@contact)
      @contact.should_receive(:phone_numbers).and_return([])
      @storage.should_receive(:save_contact)
      @command.execute(@input, @output).should eq true
    end

    it "should delete the given value from the contact's attributes" do
      phone_numbers = double(Array)
      phone_numbers.should_receive(:delete)

      @storage.should_receive(:require_contact).and_return(@contact)
      @contact.should_receive(:phone_numbers).and_return(phone_numbers)
      @storage.should_receive(:save_contact).and_return(true)
      @input.arguments = ["jdoe", "somevalue"]
      @input.options   = { :delete => true }
      @command.execute(@input, @output).should eq true
    end

  end

end

