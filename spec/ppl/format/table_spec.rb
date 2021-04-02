# encoding: UTF-8

describe Ppl::Format::Table do

  describe "#initialize" do
    it "should accept an array of columns" do
      @table = Ppl::Format::Table.new([
        :id,
        :name,
        :email,
      ])
      expect(@table.columns.length).to eq 3
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
      expect(@table.colors).to be_a(Hash)
    end
  end

  describe "#add_row" do
    it "should accept a hash" do
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      expect(@table.rows.length).to eq 1
    end
  end

  describe "#to_s" do

    it "should return an empty string if the table is empty" do
      expect(@table.to_s).to eq ""
    end

    it "should return a string represenation of its rows" do
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      expect(@table.to_s).to eq "12345  John Doe  jdoe@example.org"
    end

    it "should use tabs if requested" do
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      @table.separator = Ppl::Format::Table::SEPARATOR_TABS
      expect(@table.to_s).to eq "12345\tJohn Doe\tjdoe@example.org"
    end

    it "should colorize columns if requested" do
      @table.colors = {
        "id" => "red",
        "name" => "yellow",
        "email" => "blue",
      }
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      expect(@table.to_s).to eq "\e[31m12345  \e[0m\e[33mJohn Doe  \e[0m\e[34mjdoe@example.org  \e[0m"
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

      expect(@table.to_s).to include "12345  John Doe                    jdoe@example.org"
      expect(@table.to_s).to include "123    Luis Ignacio Lula da Silva  lula@planalto.biz"
    end

    it "copes with mixed encodings" do
      @table.add_row({
        :id    => "franz_viehböck".force_encoding("ASCII-8BIT"),
        :name  => "Franz Viehböck",
        :email => "fv@example.org",
      })
      expect{ @table.to_s }.not_to raise_error()
      expect(@table.to_s).to include "franz_viehböck  Franz Viehböck  fv@example.org"
    end

  end

  describe "#disable_colors!" do
    it "should disable colors" do
      @table.colors = {
        "id" => "red",
        "name" => "yellow",
        "email" => "blue",
      }
      @table.add_row({
        :id    => 12345,
        :name  => "John Doe",
        :email => "jdoe@example.org",
      })
      @table.disable_colors!
      expect(@table.to_s).to eq "12345  John Doe  jdoe@example.org"
    end
  end

end

