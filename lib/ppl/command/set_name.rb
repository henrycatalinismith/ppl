
class Ppl::Command::SetName < Ppl::Application::Command

  def initialize
    @name        = "name"
    @description = "Change a contact's name"
  end

  def options(parser, options)
    parser.banner = "usage: ppl name <contact> <name>"
  end

  def execute(input, output)

    contact_id = input.arguments.shift
    name       = input.arguments.shift

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    if name.nil?
      raise Ppl::Error::IncorrectUsage, "No name specified"
    end

    contact = @storage.require_contact(contact_id)
    contact.name = name.dup
    storage.save_contact(contact)

    return true
  end

end

