
class Ppl::Format::Contact::Name < Ppl::Format::Contact

  def process(contact)
    output = ""

    if !contact.name.nil?
      output += contact.name
    end

    return output
  end

end

