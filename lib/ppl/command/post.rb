
class Ppl::Command::Post < Ppl::Application::Command

  attr_writer :show_format
  attr_writer :list_format

  def initialize
    @name        = "post"
    @description = "Show or change a contact's postal address"
    @show_format = Ppl::Format::Contact::PostalAddress.new
    @list_format = Ppl::Format::AddressBook::PostalAddresses.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl post <contact> [<postal-address>]"

    parser.on("-s", "--street <street-address>") do |street|
      options[:street] = street
    end
  end

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
  end


  private

  def determine_action(input)
    if input.arguments[0].nil?
      :list_postal_addresses
    elsif input.options.empty?
      :show_postal_address
    else
      :set_postal_address
    end
  end

  def list_postal_addresses(input, output)
    address_book = @storage.load_address_book
    address_list = @list_format.process(address_book)
    output.line(address_list)
  end

  def show_postal_address(input, output)
    contact = @storage.require_contact(input.arguments[0])
    address = @show_format.process(contact)
    if address != ""
      output.line(address)
      true
    else
      false
    end
  end

  def set_postal_address(input, output)
    contact = @storage.require_contact(input.arguments[0])
    contact.set_postal_address do |address|
      address.street = input.options[:street] unless input.options[:street].nil?
    end
    @storage.save_contact(contact)
  end

end

