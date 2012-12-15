
class Ppl::Format::Table

  attr_accessor :columns
  attr_accessor :rows

  def initialize(columns=[])
    @columns = columns
    @rows    = []
  end

  def add_row(row={})
    @rows.push row
  end

  def to_s
    string = ""
    @rows.each { |row| string += format_row(row).strip }
    return string
  end


  private

  def format_row(row)
    string = ""
    @columns.each { |column| string += format_cell(row, column) }
    return string
  end

  def format_cell(row, column)
    string = sprintf("%s  ", row[column])
    return string
  end

end

