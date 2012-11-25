
class Ppl::Command::SetName < Ppl::Application::Command

  def initialize
    @name        = "name"
    @description = "Change a contact's name"
  end

  def execute(input, output)

    contact_id = input.arguments.shift
    name       = input.arguments.shift

    if contact_id.nil? || name.nil?
      raise Ppl::Error::IncorrectUsage
    end

    contact = @storage.require_contact(contact_id)

    contact.name = name.dup

    storage.save_contact(contact)

    return true
  end

end

