
class Ppl::Format::Contact::PhoneNumber < Ppl::Format::Contact

  def process(contact)
    output = ""
    if !contact.phone_number.nil?
      output += contact.phone_number
    end
    return output
  end

end

