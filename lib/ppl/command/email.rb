
class Ppl::Command::Email < Ppl::Application::Command

  name        "email"
  description "Show or change a contact's email address"

  attr_writer :email_service
  attr_writer :list_format
  attr_writer :show_format
  attr_writer :custom_format

  def options(parser, options)
    parser.banner = "usage: ppl email <contact> [<email-address>]"
    parser.on("-d", "--delete", "delete email address") do
      options[:delete] = true
    end
    parser.on("-p", "--preferred", "mark address as preferred") do
      options[:preferred] = true
    end
    parser.on("-P", "--not-preferred", "mark address as not preferred") do
      options[:preferred] = false
    end
    parser.on("--format <format>", "specify a custom output format") do |f|
      options[:format] = f
    end
  end

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
    true
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
      :update_contact_email_addresses
    end
  end

  def list_address_book_email_addresses(input, output)
    address_book = @storage.load_address_book
    output.line(@list_format.process(address_book))
  end

  def show_contact_email_addresses(input, output)
    contact = @storage.require_contact(input.arguments[0])
    output.line(format_contact(contact, input.options))
  end

  def remove_email_address_from_contact(input, output)
    contact = @storage.require_contact(input.arguments[0])
    @email_service.remove(contact, input.arguments[1])
  end

  def update_contact_email_addresses(input, output)
    contact = @storage.require_contact(input.arguments[0])
    if new_email_address?(contact, input.arguments[1])
      @email_service.add(contact, input.arguments[1], input.options)
    else
      @email_service.update(contact, input.arguments[1], input.options)
    end
  end

  def new_email_address?(contact, email_address)
    (contact.email_addresses.select { |ea| ea.address == email_address }).empty?
  end

  def format_contact(contact, options)
    if options[:format].nil?
      @show_format.process(contact)
    else
      @custom_format.format = options[:format]
      contact.email_addresses.map { |e| @custom_format.process(e) }.join("\n")
    end
  end

end

