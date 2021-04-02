class Ppl::Format::Contact::Urls < Ppl::Format::Contact

  attr_writer :color_adapter
  attr_writer :colors

  def initialize(colors={})
    @colors = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
  end

  def process(contact)
    colorize_output(contact.urls.join("\n"))
  end

  private

  def colorize_output(string)
    if @colors["urls"]
      @color_adapter.colorize(string, @colors["urls"])
    else
      string
    end
  end

end

