class Ppl::Command::Post < Ppl::Application::Command

  name        "post"
  description "List, show or change postal addresses"

  attr_writer :address_service
  attr_writer :contact_format
  attr_writer :address_book_format
  attr_writer :postal_address_format

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

    parser.on("-d", "--delete") do
      options[:delete] = true
    end
    parser.on("-m", "--move <new-id>") do |new_id|
      options[:new_id] = new_id
    end

    parser.on("-p", "--preferred", "mark address as preferred") do
      options[:preferred] = true
    end
    parser.on("-P", "--not-preferred", "mark address as not preferred") do
      options[:preferred] = false
    end

  end

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
  end


  private

  def determine_action(input)
    if input.arguments.length < 1
      :list_address_book_postal_addresses
    elsif input.arguments.length < 2
      :show_contact_postal_addresses
    elsif input.options[:delete]
      :delete_postal_address
    elsif input.options.empty?
      :show_postal_address
    elsif existing_address?(input)
      :update_postal_address
    else
      :create_postal_address
    end
  end

  def existing_address?(input)
    @contact = @storage.require_contact(input.arguments[0])
    !@contact.postal_addresses.find { |p| p.id == input.arguments[1] }.nil?
  end

  def list_address_book_postal_addresses(input, output)
    address_book = @storage.load_address_book
    address_list = @address_book_format.process(address_book)
    output.line(address_list)
  end

  def show_contact_postal_addresses(input, output)
    contact = @storage.require_contact(input.arguments[0])
    address = @contact_format.process(contact)
    if address != ""
      output.line(address)
      true
    else
      false
    end
  end

  def show_postal_address(input, output)
    contact = @storage.require_contact(input.arguments[0])
    address = contact.postal_addresses.find { |pa| pa.id == input.arguments[1] }
    if address.nil?
      raise Ppl::Error::PostalAddressNotFound, input.arguments[1]
    end
    display = @postal_address_format.process(address)
    output.line(display)
    true
  end

  def delete_postal_address(input, output)
    contact = @storage.require_contact(input.arguments[0])
    @address_service.remove(contact, input.arguments[1])
    @storage.save_contact(contact)
    true
  end

  def update_postal_address(input, output)
    @address_service.update(@contact, input.arguments[1], input.options)
    @storage.save_contact(@contact)
    true
  end

  def create_postal_address(input, output)
    @address_service.add(@contact, input.arguments[1], input.options)
    @storage.save_contact(@contact)
    true
  end

end

