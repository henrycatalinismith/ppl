
class Ppl::Command::Show < Ppl::Command

  def name
    "contact:show"
  end

  def summary
    "Show full details of a single contact"
  end

  def banner
    "Usage: ppl contact:show <contact>"
  end

  def options(parser)
  end

  def execute(argv, options)

    contact_id = argv.first

    if contact_id.nil?
      $stderr.puts @option_parser
      return false
    end

    contact = @address_book.contact contact_id
    if contact.nil?
      raise "contact '#{contact_id}' not found"
    end


    puts contact.name
    contact.emails.each do |email|
      puts email
    end

    return true
  end

end

