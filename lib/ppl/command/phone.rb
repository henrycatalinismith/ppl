
class Ppl::Command::Phone < Ppl::Command::Attribute

  name        "phone"
  description "List, show or change phone numbers"

  def initialize
    @show_format = Ppl::Format::Contact::PhoneNumber.new
    @list_format = Ppl::Format::AddressBook::PhoneNumbers.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl phone <contact> [<number>]"
  end


  private

  def set_phone_number(input, output)
    contact = @storage.require_contact(input.arguments[0])
    contact.phone_number = input.arguments[1]
    @storage.save_contact(contact)
  end

end

