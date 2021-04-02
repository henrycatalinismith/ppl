class Ppl::Command::Rm < Ppl::Application::Command

  name        "rm"
  description "Delete a contact"

  def options(parser, options)
    parser.banner = "usage: ppl rm <contact>"
  end

  def execute(input, output)
    contact_id = input.arguments.first

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    contact = @storage.require_contact(contact_id)
    @storage.delete_contact(contact)
    return true
  end

end

