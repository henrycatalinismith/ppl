
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

  describe "#colors" do
    it "should be a hash" do
      @table.colors.should be_a(Hash)
    end
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

    it "should return a string represenation of its rows" do
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      @table.to_s.should eq "12345  John Doe  jdoe@example.org"
    end

    it "should use tabs if requested" do
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      @table.separator = Ppl::Format::Table::SEPARATOR_TABS
      @table.to_s.should eq "12345\tJohn Doe\tjdoe@example.org"
    end

    it "should colorise columns if requested" do
      @table.colors = {
        :id => "red",
        :name => "yellow",
        :email => "blue",
      }
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      @table.to_s.should eq "\e[31m12345\e[0m  \e[33mJohn Doe\e[0m  \e[34mjdoe@example.org\e[0m"
    end

    it "should align multiple rows into neat columns" do
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      @table.add_row({
        :id    => 123,
        :name  => "Luis Ignacio Lula da Silva",
        :email => "lula@planalto.biz",
      })

      @table.to_s.should include "12345  John Doe                    jdoe@example.org"
      @table.to_s.should include "123    Luis Ignacio Lula da Silva  lula@planalto.biz"
    end

  end

end

