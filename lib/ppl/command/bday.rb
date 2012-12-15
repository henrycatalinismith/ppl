
class Ppl::Command::Bday < Ppl::Application::Command

  attr_writer :format

  def initialize
    @name        = "bday"
    @description = "Show or change a contact's birthday"
    @format      = Ppl::Format::Contact::Birthday.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl birthday <contact> [<date>]"
  end

  def execute(input, output)

    contact_id = input.arguments.shift
    birthday   = input.arguments.shift

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    contact = @storage.require_contact(contact_id)

    if birthday.nil?
      show_birthday(contact, output)
    else
      set_birthday(contact, birthday)
    end

    return true
  end

  def show_birthday(contact, output)
    line = @format.process(contact)
    output.line(line)
  end

  def set_birthday(contact, birthday)
    begin
      date = Date.parse birthday
    rescue ArgumentError
      raise Ppl::Error::IncorrectUsage, "Invalid date '#{birthday}'"
    end
    contact.birthday = date
    @storage.save_contact(contact)
  end

end

