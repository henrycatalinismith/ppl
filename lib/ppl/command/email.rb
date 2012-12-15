
class Ppl::Command::Email < Ppl::Application::Command

  attr_writer :format

  def initialize
    @name        = "email"
    @description = "Show or change a contact's email address"
    @format      = Ppl::Format::Contact::EmailAddress.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl email <contact> [<email-address>]"
  end

  def execute(input, output)

    contact_id    = input.arguments.shift
    email_address = input.arguments.shift

    if contact_id.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    contact = @storage.require_contact(contact_id)

    if email_address.nil?
      show_email_address(contact, output)
    else
      set_email_address(contact, email_address)
    end

    return true
  end

  private

  def show_email_address(contact, output)
    output.line(@format.process(contact))
  end

  def set_email_address(contact, address)
    contact.email_address = address
    @storage.save_contact(contact)
  end

end

