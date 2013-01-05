
class Ppl::Format::Contact::Urls < Ppl::Format::Contact

  def process(contact)
    lines = []
    contact.urls.each do |url|
      lines.push url
    end
    lines.join("\n")
  end

end

