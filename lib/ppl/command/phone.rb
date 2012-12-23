
class Ppl::Command::Phone < Ppl::Application::Command

  name        "phone"
  description "List, show or change phone numbers"

  attr_writer :show_format
  attr_writer :list_format

  def initialize
    @show_format = Ppl::Format::Contact::PhoneNumber.new
    @list_format = Ppl::Format::AddressBook::PhoneNumbers.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl phone <contact> [<number>]"
  end

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
  end


  private

  def determine_action(input)
    if input.arguments[0].nil?
      :list_phone_numbers
    elsif input.arguments[1].nil?
      :show_phone_number
    else
      :set_phone_number
    end
  end

  def list_phone_numbers(input, output)
    address_book = @storage.load_address_book
    number_list  = @list_format.process(address_book)
    output.line(number_list)
  end

  def show_phone_number(input, output)
    contact = @storage.require_contact(input.arguments[0])
    number  = @show_format.process(contact)
    if number != ""
      output.line(number)
      true
    else
      false
    end
  end

  def set_phone_number(input, output)
    contact = @storage.require_contact(input.arguments[0])
    contact.phone_number = input.arguments[1]
    @storage.save_contact(contact)
  end

end

