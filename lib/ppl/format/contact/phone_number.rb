
class Ppl::Format::Contact::PhoneNumber < Ppl::Format::Contact

  attr_writer :table

  def initialize(colors={})
    @table = Ppl::Format::Table.new([:number, :type], colors)
  end

  def process(contact)
    contact.phone_numbers.each { |pn| add_row(pn) }
    @table.to_s
  end

  private

  def add_row(phone_number)
    @table.add_row({
      :number => phone_number.number,
      :type   => format_type(phone_number.type),
    })
  end

  def format_type(type)
    unless type.nil? || type == ""
      "(#{type})"
    end
  end

end

