
class Ppl::Format::Contact::PhoneNumber < Ppl::Format::Contact

  def process(contact)
    contact.phone_numbers.join("\n")
  end

end

