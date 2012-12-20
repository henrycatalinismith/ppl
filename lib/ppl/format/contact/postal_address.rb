
class Ppl::Format::Contact::PostalAddress < Ppl::Format::Contact

  def process(contact)
    output = ""
    if !contact.postal_address.nil?
      output += contact.postal_address
    end
    return output
  end

end

