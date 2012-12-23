
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

    [:country, :locality, :region, :po_box, :postal_code, :street].each do |property|
      next if input.options[property].nil?
      contact.set_postal_address do |address|
        address.send("#{property.to_s}=", input.options[property])
      end
    end

    @storage.save_contact(contact)
  end

end

