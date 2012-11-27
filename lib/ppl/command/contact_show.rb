
class Ppl::Command::ContactShow < Ppl::Application::Command

  attr_writer :format

  def initialize
    @name        = "show"
    @description = "Display the full details of a contact"

    @format = Ppl::Format::Contact::Full.new
  end

  def execute(input, output)
    contact_id  = input.arguments.shift
    contact     = @storage.require_contact(contact_id)

    formatted = @format.process(contact)

    output.line(formatted)

    return true
  end

end

