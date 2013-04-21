
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
    if new_number?(contact, input.arguments[0])
      add_new_number(contact, input)
    else
      update_existing_number(contact, input)
    end
    @storage.save_contact(contact)
    true
  end

  def remove_attribute(input, output)
    contact = @storage.require_contact(input.arguments[0])
    contact.phone_numbers.select! { |pn| pn.number != input.arguments[1] }
    @storage.save_contact(contact)
  end

  def new_number?(contact, input_number)
    matching_numbers = contact.phone_numbers.select do |pn|
      pn.number == input_number
    end
    matching_numbers.length < 1
  end

  def add_new_number(contact, input)
    phone_number = Ppl::Entity::PhoneNumber.new
    phone_number.number = input.arguments[0]
    phone_number.type = input.options[:type]
    contact.phone_numbers << phone_number
  end

  def update_existing_number(contact, input)
    contact.phone_numbers.each do |pn|
      if pn.number == input.arguments[0]
        pn.type = input.options[:type]
      end
    end
  end

end

