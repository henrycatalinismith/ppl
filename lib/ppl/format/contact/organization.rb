
class Ppl::Format::Contact::Organization < Ppl::Format::Contact

  def process(contact)
    output = ""
    if !contact.organization.nil?
      output += contact.organization
    end
    return output
  end

end

