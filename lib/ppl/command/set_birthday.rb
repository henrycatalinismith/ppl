
class Ppl::Command::SetBirthday < Ppl::Application::Command

  def initialize
    @name        = "birthday"
    @description = "Change a contact's birthday"
  end

  def options(parser, options)
    parser.banner = "usage: ppl birthday <contact> <date>"
  end

  def execute(input, output)

    contact_id = input.arguments.shift
    birthday   = input.arguments.shift

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    if birthday.nil?
      raise Ppl::Error::IncorrectUsage, "No date specified"
    end

    begin
      date = Date.parse birthday
    rescue ArgumentError
      raise Ppl::Error::IncorrectUsage, "Invalid date '#{birthday}'"
    end

    contact = @storage.require_contact(contact_id)

    contact.birthday = date

    storage.save_contact(contact)

    return true
  end

end

