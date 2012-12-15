
class Ppl::Format::Table

  attr_accessor :columns
  attr_accessor :rows

  def initialize(columns=[])
    @columns = columns
    @rows    = []

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
    width  = @column_widths[column]
    string = sprintf("%-#{width}s  ", row[column])
    return string
  end

end

