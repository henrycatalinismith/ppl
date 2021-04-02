class Ppl::Format::Contact::Birthday < Ppl::Format::Contact

  attr_writer :color_adapter
  attr_writer :colors

  def initialize(colors={})
    @colors = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
  end

  def process(contact)
    output = ""
    if !contact.birthday.nil?
      output += contact.birthday.strftime("%Y-%m-%d")
    end
    if @colors["birthday"]
      output = @color_adapter.colorize(output, @colors["birthday"])
    end
    return output
  end

end

