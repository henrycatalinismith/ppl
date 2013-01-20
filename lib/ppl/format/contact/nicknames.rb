
class Ppl::Format::Contact::Nicknames < Ppl::Format::Contact

  def process(contact)
    contact.nicknames.join("\n")
  end

end

