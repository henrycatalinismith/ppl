describe Ppl::Application::Command do

  before(:each) do
    @command = Ppl::Application::Command.new
  end

  describe "#execute" do
    it "should raise not implemented error" do
      expect{@command.execute(nil, nil)}.to raise_error(NotImplementedError)
    end
  end

  describe "#storage=" do
    it "should accept a storage adapter" do
      storage = double(Ppl::Adapter::Storage)
      @command.storage = storage
      expect(@command.storage).to be storage
    end
  end

  describe "#add_property" do
    it "should allow new properties to be defined" do
      class TestCommand123 < Ppl::Application::Command
        add_property :some_property
      end
    end

    it "should allow properties to have values assigned to them" do
      class TestCommand456 < Ppl::Application::Command
        add_property :some_property
        some_property "a value"
      end
      expect(TestCommand456.some_property).to eq "a value"
    end

    it "should expose properties as instance variables too" do
      class TestCommand789 < Ppl::Application::Command
        add_property :some_property
        some_property "a value"
      end
      instance = TestCommand789.new
      expect(instance.some_property).to eq "a value"
    end

    it "should allow properties to be overwritten by instance variables" do
      class TestCommand901 < Ppl::Application::Command
        add_property :some_property
        some_property "a value"
      end
      instance = TestCommand901.new
      instance.some_property = "different"
      expect(instance.some_property).to eq "different"
    end
  end

  describe "#name=" do
    it "should allow the name to be set as an instance variable" do
      @command.name = "testing"
      expect(@command.name).to eq "testing"
    end
  end

  describe "#description=" do
    it "should allow the description to be set as an instance variable" do
      @command.description = "testing"
      expect(@command.description).to eq "testing"
    end
  end

  describe "#name" do
    it "should allow the name to be set as a class variable" do
      class TestCommand123 < Ppl::Application::Command
        name "new_for_test"
      end
      command = TestCommand123.new
      expect(command.name).to eq "new_for_test"
    end
  end

  describe "#desecription" do
    it "should allow the description to be set as a class variable" do
      class TestCommand123 < Ppl::Application::Command
        description "desc_for_test"
      end
      command = TestCommand123.new
      expect(command.description).to eq "desc_for_test"
    end
  end

end

