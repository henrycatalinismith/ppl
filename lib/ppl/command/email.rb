
class Ppl::Command::Email < Ppl::Application::Command

  name        "email"
  description "Show or change a contact's email address"

  attr_writer :email_service
  attr_writer :list_format
  attr_writer :show_format

  def options(parser, options)
    parser.banner = "usage: ppl email <contact> [<email-address>]"
    parser.on("-d", "--delete", "delete email address") do
      options[:delete] = true
    end
  end

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
  end

  private

  def determine_action(input)
    if input.arguments.length < 1
      :list_address_book_email_addresses
    elsif input.arguments.length < 2
      :show_contact_email_addresses
    elsif input.options[:delete]
      :remove_email_address_from_contact
    else
      :add_email_address_to_contact
    end
  end

  def list_address_book_email_addresses(input, output)
    address_book = @storage.load_address_book
    output.line(@list_format.process(address_book))
  end

  def show_contact_email_addresses(input, output)
    contact = @storage.require_contact(input.arguments[0])
    output.line(@show_format.process(contact))
  end

  def add_email_address_to_contact(input, output)
    contact = @storage.require_contact(input.arguments[0])
    @email_service.add(contact, input.arguments[1])
  end

  def remove_email_address_from_contact(input, output)
    contact = @storage.require_contact(input.arguments[0])
    @email_service.remove(contact, input.arguments[1])
  end

end

