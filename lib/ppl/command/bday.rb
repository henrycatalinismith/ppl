
class Ppl::Command::Bday < Ppl::Application::Command

  name        "bday"
  description "List, show or change birthdays"

  attr_writer :list_format
  attr_writer :show_format

  def options(parser, options)
    parser.banner = "usage: ppl birthday <contact> [<date>]"
  end

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
  end


  private

  def determine_action(input)
    if input.arguments[0].nil?
      :list_birthdays
    elsif input.arguments[1].nil?
      :show_birthday
    else
      :set_birthday
    end
  end

  def list_birthdays(input, output)
    address_book  = @storage.load_address_book
    birthday_list = @list_format.process(address_book)
    output.line(birthday_list)
  end

  def show_birthday(input, output)
    contact_id = input.arguments.shift
    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end
    contact = @storage.require_contact(contact_id)

    birthday = @show_format.process(contact)
    if birthday != ""
      output.line(birthday)
      true
    else
      false
    end
  end

  def set_birthday(input, output)
    contact_id = input.arguments.shift
    birthday   = input.arguments.shift

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end
    contact = @storage.require_contact(contact_id)

    begin
      date = Date.parse birthday
    rescue ArgumentError
      raise Ppl::Error::IncorrectUsage, "Invalid date '#{birthday}'"
    end
    contact.birthday = date
    @storage.save_contact(contact)
  end

end

