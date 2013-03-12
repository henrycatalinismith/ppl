
class Ppl::Format::Contact::PhoneNumber < Ppl::Format::Contact

  attr_writer :color_adapter
  attr_writer :colors

  def initialize(colors={})
    @colors = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
  end

  def process(contact)
    colorize_output(contact.phone_numbers.join("\n"))
  end

  private

  def colorize_output(string)
    if @colors["phone_numbers"]
      @color_adapter.colorize(string, @colors["phone_numbers"])
    else
      string
    end
  end

end

