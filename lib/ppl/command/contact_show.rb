
class Ppl::Command::ContactShow < Ppl::Application::Command

  def initialize
    @name        = "show"
    @description = "Display the full details of a contact"
  end

  def execute(input, output)
    contact_id  = input.arguments.shift
    contact     = @storage.require_contact(contact_id)

    output.line(contact.name)
    output.line(contact.email_address)

    return true
  end

end

