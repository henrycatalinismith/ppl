
class Ppl::Format::Contact::PhoneNumber < Ppl::Format::Contact

  attr_writer :color_adapter
  attr_writer :colors

  def initialize(colors={})
    @colors = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
  end

  def process(contact)
    list = stringify_phone_numbers(contact.phone_numbers)
    list = colorize_output(list)
    list
  end

  private

  def stringify_phone_numbers(phone_numbers)
    phone_numbers.map(&method(:stringify_phone_number)).join("\n")
  end

  def stringify_phone_number(phone_number)
    line = [phone_number.number]
    unless phone_number.type.nil? || phone_number.type == ""
      line << "(#{phone_number.type})"
    end
    line.join " "
  end

  def colorize_output(string)
    if @colors["phone_numbers"]
      @color_adapter.colorize(string, @colors["phone_numbers"])
    else
      string
    end
  end

end

