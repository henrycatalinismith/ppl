
class Ppl::Command::Phone < Ppl::Application::Command

  attr_writer :format

  def initialize
    @name        = "phone"
    @description = "Show or change a contact's phone number"
    @format      = Ppl::Format::Contact::PhoneNumber.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl phone <contact> [<number>]"
  end

  def execute(input, output)

    contact_id   = input.arguments.shift
    phone_number = input.arguments.shift

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    contact = @storage.require_contact(contact_id)

    if phone_number.nil?
      show_phone_number(contact, output)
    else
      set_phone_number(contact, phone_number)
    end

    return true
  end

  private

  def show_phone_number(contact, output)
    output.line(@format.process(contact))
  end

  def set_phone_number(contact, phone_number)
    contact.phone_number = phone_number
    @storage.save_contact(contact)
  end

end

