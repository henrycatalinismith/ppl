
class Ppl::Command::SetPhoneNumber < Ppl::Application::Command

  def initialize
    @name        = "phone"
    @description = "Change a contact's phone number"
  end

  def options(parser, options)
    parser.banner = "usage: ppl phone <contact> <number>"
  end

  def execute(input, output)

    contact_id   = input.arguments.shift
    phone_number = input.arguments.shift

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    if phone_number.nil?
      raise Ppl::Error::IncorrectUsage, "No phone number specified"
    end

    contact = @storage.require_contact(contact_id)
    contact.phone_number = phone_number
    storage.save_contact(contact)

    return true
  end

end

