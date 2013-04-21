
class Ppl::Format::Contact::EmailAddresses < Ppl::Format::Contact

  attr_writer :color_adapter
  attr_writer :colors

  def initialize(colors={})
    @colors = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
  end

  def process(contact)
    lines = []
    contact.email_addresses.each do |email_address|
      lines << email_address.address
    end
    colorize_output(lines.join("\n"))
  end

  private

  def colorize_output(string)
    if @colors["email_addresses"]
      @color_adapter.colorize(string, @colors["email_addresses"])
    else
      string
    end
  end

end

