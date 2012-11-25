
class Ppl::Command::SetEmail < Ppl::Application::Command

  def initialize
    @name        = "email"
    @description = "Change a contact's email address"
  end

  def execute(input, output)

    contact_id    = input.arguments.shift
    email_address = input.arguments.shift

    contact = @storage.require_contact(contact_id)
    contact.email_address = email_address

    storage.save_contact(contact)

    return true
  end

end

