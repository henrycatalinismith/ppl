
require "colored"

class Ppl::Format::Table

  SEPARATOR_SPACES = 0
  SEPARATOR_TABS   = 1

  attr_accessor :columns
  attr_accessor :rows
  attr_accessor :separator
  attr_accessor :colors

  def initialize(columns=[])
    @columns   = columns
    @rows      = []
    @separator = SEPARATOR_SPACES
    @colors    = {}
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
    value = colorise_string(row[column].to_s, column)
    if @separator == SEPARATOR_SPACES
      string = sprintf("%-#{width}s  ", value)
    else
      string = sprintf("%s\t", value)
    end
    return string
  end

  def colorise_string(string, column)
    if !@colors[column].nil?
      string.send(@colors[column])
    else
      string
    end
  end

end

