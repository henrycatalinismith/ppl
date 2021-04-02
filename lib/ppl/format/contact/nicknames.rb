class Ppl::Format::Contact::Nicknames < Ppl::Format::Contact

  attr_writer :color_adapter
  attr_writer :colors

  def initialize(colors={})
    @colors = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
  end

  def process(contact)
    colorize_output(contact.nicknames.join("\n"))
  end

  private

  def colorize_output(string)
    if @colors["nicknames"]
      @color_adapter.colorize(string, @colors["nicknames"])
    else
      string
    end
  end

end

