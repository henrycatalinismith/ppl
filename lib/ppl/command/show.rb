
class Ppl::Command::Show < Ppl::Command

  def name
    "show"
  end

  def summary
    "Show full details of a single contact"
  end

  def index
    contact = @address_book.contact @arguments.first

    puts contact.name
    contact.emails.each do |email|
      puts email
    end

  end

end

