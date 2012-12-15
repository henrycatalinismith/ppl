
class Ppl::Format::Contact::Birthday < Ppl::Format::Contact

  def process(contact)
    output = ""
    if !contact.birthday.nil?
      output += contact.birthday.strftime("%Y-%m-%d")
    end
    return output
  end

end

