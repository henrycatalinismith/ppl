
class Ppl::Command::Phone < Ppl::Command::Attribute

  name        "phone"
  description "List, show or change phone numbers"

  def initialize
    @attribute = :phone_numbers
  end

  def options(parser, options)
    parser.banner = "usage: ppl phone <contact> [<number>]"
    parser.on("-d", "--delete", "delete phone number") do
      options[:delete] = true
    end
    parser.on("-t", "--type <type>") do |type|
      options[:type] = type
    end
  end

  def add_attribute(input, output)
    contact = @storage.require_contact(input.arguments.shift)
    phone_number = Ppl::Entity::PhoneNumber.new
    phone_number.number = input.arguments.shift
    phone_number.type = input.options[:type]
    contact.phone_numbers.push(phone_number)
    @storage.save_contact(contact)
    true
  end

end

