
class Ppl::Format::Contact::Organization < Ppl::Format::Contact

  attr_writer :color_adapter
  attr_writer :colors

  def initialize(colors={})
    @colors = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
  end

  def process(contact)
    colorize_output(contact.organizations.join("\n"))
  end

  private

  def colorize_output(string)
    if @colors["organizations"]
      @color_adapter.colorize(string, @colors["organizations"])
    else
      string
    end
  end

end

