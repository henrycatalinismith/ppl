
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
    parser.on("-t", "--type <type>") do |type|
      options[:type] = type
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

end

