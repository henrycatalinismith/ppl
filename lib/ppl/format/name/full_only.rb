class Ppl::Format::Name::FullOnly < Ppl::Format::Name

  attr_writer :color_adapter
  attr_writer :colors

  def initialize(colors={})
    @colors = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
  end

  def process(name)
    output = ""
    if !name.full.nil?
      output += name.full
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

