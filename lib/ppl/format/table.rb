
require "colored"

class Ppl::Format::Table

  SEPARATOR_SPACES = 0
  SEPARATOR_TABS   = 1

  attr_accessor :columns
  attr_accessor :rows
  attr_accessor :separator
  attr_accessor :colors

  def initialize(columns=[], colors={})
    @columns   = columns
    @rows      = []
    @separator = SEPARATOR_SPACES
    @colors    = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
    @column_widths = {}
    @columns.each { |c| @column_widths[c] = 0 }
  end

  def add_row(row={})
    row.each do |column, value|
      width     = sprintf("%s", value).length
      max_width = @column_widths[column]
      if width > max_width
        @column_widths[column] = width
      end
    end
    @rows.push(row)
  end

  def to_s
    string = ""
    @rows.each { |row| string += format_row(row).strip + "\n" }
    string.strip
  end


  private

  def format_row(row)
    string = ""
    @columns.each { |column| string += format_cell(row, column) }
    return string
  end

  def format_cell(row, column)
    width = @column_widths[column]
    string = row[column].to_s
    if @separator == SEPARATOR_SPACES
      string = sprintf("%-#{width}s  ", string)
    else
      string = sprintf("%s\t", string)
    end
    colorize_string(string, column)
  end

  def colorize_string(string, column)
    @color_adapter.colorize(string, @colors[column.to_s])
  end

end

