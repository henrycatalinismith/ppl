
describe Ppl::Format::Table do

  describe "#initialize" do
    it "should accept an array of columns" do
      @table = Ppl::Format::Table.new([
        :id,
        :name,
        :email,
      ])
      @table.columns.length.should eq 3
    end
  end

end

describe Ppl::Format::Table do

  before(:each) do
    @table = Ppl::Format::Table.new([
      :id,
      :name,
      :email,
    ])
  end

  describe "#add_row" do
    it "should accept a hash" do
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      @table.rows.length.should eq 1
    end
  end

  describe "#to_s" do

    it "should return an empty string if the table is empty" do
      @table.to_s.should eq ""
    end

    it "should do some stuff" do
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      @table.to_s.should eq "12345  John Doe  jdoe@example.org"
    end

  end

end

