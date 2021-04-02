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
      expect(@storage).to receive(:load_address_book).and_return(@address_book)
      expect(@list_format).to receive(:process).and_return("imagine this is a list")
      expect(@output).to receive(:line).with("imagine this is a list")
      expect(@command.execute(@input, @output)).to eq true
    end

    it "should disable color output if :no_color is set" do
      @input.options[:no_color] = true
      allow(@storage).to receive(:load_address_book).and_return(@address_book)
      expect(@list_format).to receive(:disable_colors!)
      allow(@list_format).to receive(:process)
      expect(@output).to receive(:line)
      expect(@command.execute(@input, @output)).to eq true
    end

    it "should show the full list of attributes for the given contact" do
      @input.arguments.push("jdoe")
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@show_format).to receive(:process).and_return("all the info")
      expect(@output).to receive(:line).with("all the info")
      expect(@command.execute(@input, @output)).to eq true
    end

    it "should add the given value to the contact's attributes" do
      @input.arguments.push("jdoe", "anyvalue")
      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@contact).to receive(:phone_numbers).and_return([])
      expect(@storage).to receive(:save_contact)
      expect(@command.execute(@input, @output)).to eq true
    end

    it "should delete the given value from the contact's attributes" do
      phone_numbers = double(Array)
      expect(phone_numbers).to receive(:delete)

      expect(@storage).to receive(:require_contact).and_return(@contact)
      expect(@contact).to receive(:phone_numbers).and_return(phone_numbers)
      expect(@storage).to receive(:save_contact).and_return(true)
      @input.arguments = ["jdoe", "somevalue"]
      @input.options   = { :delete => true }
      expect(@command.execute(@input, @output)).to eq true
    end

  end

end

