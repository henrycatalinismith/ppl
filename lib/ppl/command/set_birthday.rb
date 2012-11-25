
class Ppl::Command::SetBirthday < Ppl::Application::Command

  def initialize
    @name        = "birthday"
    @description = "Change a contact's birthday"
  end

  def execute(input, output)

    contact_id = input.arguments.shift
    birthday   = input.arguments.shift

    if contact_id.nil? || birthday.nil?
      raise Ppl::Error::IncorrectUsage
    end

    birthday = Date.parse birthday

    contact = @storage.require_contact(contact_id)

    contact.birthday = birthday

    storage.save_contact(contact)

    return true
  end

end

