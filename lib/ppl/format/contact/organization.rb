
class Ppl::Format::Contact::Organization < Ppl::Format::Contact

  def process(contact)
    contact.organizations.join("\n")
  end

end

