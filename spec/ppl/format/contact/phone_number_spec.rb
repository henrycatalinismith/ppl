describe Ppl::Format::Contact::PhoneNumber do

  describe "#initialize" do
    it "should pass the colors through to the table" do
      colors = {"number" => "blue"}
      expect(Ppl::Format::Table).to receive(:new).with([:star, :phone_numbers, :type], colors)
      format = Ppl::Format::Contact::PhoneNumber.new(colors)
    end
  end

  describe "#process" do

    before(:each) do
      @contact = Ppl::Entity::Contact.new
      @number  = Ppl::Entity::PhoneNumber.new("01234567890")
      @format  = Ppl::Format::Contact::PhoneNumber.new
      @table   = double(Ppl::Format::Table)
      @format.table = @table
      @contact.phone_numbers << @number
    end

    it "should always include the phone number" do
      expect(@table).to receive(:add_row).with({
        :star          => " ",
        :phone_numbers => "01234567890",
        :type          => nil,
      })
      @format.process(@contact)
    end

    it "should put the type in parentheses" do
      @number.type = "work"
      expect(@table).to receive(:add_row).with({
        :star          => " ",
        :phone_numbers => "01234567890",
        :type          => "(work)",
      })
      @format.process(@contact)
    end

    it "should mark preferred numbers with a star" do
      @number.preferred = true
      expect(@table).to receive(:add_row).with({
        :star          => "*",
        :phone_numbers => "01234567890",
        :type          => nil,
      })
      @format.process(@contact)
    end

  end

end


