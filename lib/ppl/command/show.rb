class Ppl::Command::Show < Ppl::Application::Command

  name        "show"
  description "Display the full details of a contact"

  attr_writer :format

  def initialize
    @format = Ppl::Format::Contact::Full.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl show <contact>"
  end

  def execute(input, output)
    contact_id = input.arguments.shift
    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    contact   = @storage.require_contact(contact_id)
    formatted = @format.process(contact)

    output.line(formatted)
    return true
  end

end

