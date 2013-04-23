
class Ppl::Command::Phone < Ppl::Application::Command

  name        "phone"
  description "List, show or change phone numbers"

  attr_writer :phone_service
  attr_writer :list_format
  attr_writer :show_format

  def options(parser, options)
    parser.banner = "usage: ppl phone <contact> [<number>]"
    parser.on("-d", "--delete", "delete phone number") do
      options[:delete] = true
    end
    parser.on("-t", "--type <type>", "set the phone number's type") do |type|
      options[:type] = type
    end
    parser.on("-p", "--preferred", "mark phone number as preferred") do
      options[:preferred] = true
    end
    parser.on("-P", "--not-preferred", "mark phone number as not preferred") do
      options[:preferred] = false
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
      :list_address_book_phone_numbers
    elsif input.arguments.length < 2
      :show_contact_phone_numbers
    elsif input.options[:delete]
      :remove_phone_number_from_contact
    else
      :update_contact_phone_numbers
    end
  end

  def list_address_book_phone_numbers(input, output)
    address_book = @storage.load_address_book
    output.line(@list_format.process(address_book))
  end

  def show_contact_phone_numbers(input, output)
    contact = @storage.require_contact(input.arguments[0])
    output.line(@show_format.process(contact))
  end

  def remove_phone_number_from_contact(input, output)
    contact = @storage.require_contact(input.arguments[0])
    @phone_service.remove(contact, input.arguments[1])
  end

  def update_contact_phone_numbers(input, output)
    contact = @storage.require_contact(input.arguments[0])
    if new_phone_number?(contact, input.arguments[1])
      @phone_service.add(contact, input.arguments[1])
    else
      @phone_service.update(contact, input.arguments[1], input.options)
    end
  end

  def new_phone_number?(contact, number)
    (contact.phone_numbers.select { |pn| pn.number == number }).empty?
  end

end

