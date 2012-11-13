
class Ppl::Command::Show < Ppl::Command

  def name
    "show"
  end

  def summary
    "Show full details of a single contact"
  end

  def banner
    "Usage: ppl show <contact>"
  end

  def options(parser)
  end

  def execute(argv, options)

    contact = @address_book.contact argv.first

    puts contact.name
    contact.emails.each do |email|
      puts email
    end

  end

end

