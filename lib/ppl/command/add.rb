
class Ppl::Command::Add < Ppl::Command

  def name
    "add"
  end

  def summary
    "Add a new contact"
  end

  def banner
    "Usage: ppl add <contact>"
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
    if !contact.nil?
      raise "contact '#{contact_id}' already exists"
    end

    contact = @address_book.create_contact contact_id
    puts contact

  end

end

