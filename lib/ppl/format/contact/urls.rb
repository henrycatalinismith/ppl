
class Ppl::Format::Contact::Urls < Ppl::Format::Contact

  def process(contact)
    contact.urls.join("\n")
  end

end

