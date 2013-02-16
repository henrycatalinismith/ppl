
class Ppl::Format::Contact::Age < Ppl::Format::Contact

  def process(contact)
    contact.age(Date.today).to_s
  end

end

