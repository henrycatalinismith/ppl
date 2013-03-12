
class Ppl::Format::Contact::Name < Ppl::Format::Contact

  attr_writer :color_adapter
  attr_writer :colors

  def initialize(colors={})
    @colors = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
  end

  def process(contact)
    output = ""
    if !contact.name.nil?
      output += contact.name
    end
    colorize_output(output)
  end

  private

  def colorize_output(string)
    if @colors["name"]
      @color_adapter.colorize(string, @colors["name"])
    else
      string
    end
  end

end

