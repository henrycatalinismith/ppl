
class Ppl::Format::Contact::EmailAddresses < Ppl::Format::Contact

  def process(contact)
    lines = []
    contact.email_addresses.each do |email_address|
      lines.push email_address
    end
    lines.join("\n")
  end

end

