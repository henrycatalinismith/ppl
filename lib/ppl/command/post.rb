
class Ppl::Command::Post < Ppl::Application::Command

  attr_writer :show_format
  attr_writer :list_format

  def initialize
    @name        = "post"
    @description = "List, show or change postal addresses"
    @show_format = Ppl::Format::Contact::PostalAddress.new
    @list_format = Ppl::Format::AddressBook::PostalAddresses.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl post <contact> [address]"

    parser.on("-s", "--street <street-address>") do |street|
      options[:street] = street
    end
    parser.on("-z", "--postal-code <postal-code>") do |postal_code|
      options[:postal_code] = postal_code
    end
    parser.on("-p", "--po-box <po-box>") do |po_box|
      options[:po_box] = po_box
    end
    parser.on("-l", "--locality <locality>") do |locality|
      options[:locality] = locality
    end
    parser.on("-r", "--region <region>") do |region|
      options[:region] = region
    end
    parser.on("-c", "--country <country>") do |country|
      options[:country] = country
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
      address.country     = input.options[:country]     unless input.options[:country].nil?
      address.locality    = input.options[:locality]   unless input.options[:locality].nil?
      address.region      = input.options[:region]      unless input.options[:region].nil?
      address.po_box      = input.options[:po_box]      unless input.options[:po_box].nil?
      address.postal_code = input.options[:postal_code] unless input.options[:postal_code].nil?
      address.street      = input.options[:street]      unless input.options[:street].nil?
    end
    @storage.save_contact(contact)
  end

end

