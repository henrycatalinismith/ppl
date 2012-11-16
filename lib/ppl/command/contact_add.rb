
class Ppl::Command::Add < Ppl::Command

  def name
    "contact:add"
  end

  def summary
    "Add a new contact"
  end

  def banner
    "Usage: ppl contact:add <contact> <name>"
  end

  def options(parser)
  end

  def commit_on_success
    true
  end

  def execute(argv, options)

    contact_id = argv.shift
    name       = argv.shift

    if contact_id.nil? || name.nil?
      $stderr.puts @option_parser
      return false
    end

    contact = @address_book.contact contact_id
    if !contact.nil?
      raise "contact '#{contact_id}' already exists"
    end

    contact = @address_book.create_contact contact_id, name
    puts contact

  end

end

