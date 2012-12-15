
class Ppl::Format::Contact::EmailAddress < Ppl::Format::Contact

  def process(contact)
    output = ""
    if !contact.email_address.nil?
      output += contact.email_address
    end
    return output
  end

end

