
class Ppl::Command::Phone < Ppl::Command::Attribute

  name        "phone"
  description "List, show or change phone numbers"

  def initialize
    @attribute   = :phone_numbers
    @show_format = Ppl::Format::Contact::PhoneNumber.new
    @list_format = Ppl::Format::AddressBook::PhoneNumbers.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl phone <contact> [<number>]"
  end

end

