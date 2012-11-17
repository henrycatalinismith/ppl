
class Ppl::Command::Move < Ppl::Command

  def name
    "mv"
  end

  def summary
    "Rename a contact"
  end

  def banner
    "Usage: ppl mv <contact> <new name>"
  end

  def options(parser)
  end

  def commit_on_success
    true
  end

  def execute(argv, options)

    contact_id = argv.shift
    new_id     = argv.shift

    if contact_id.nil? || new_id.nil?
      $stderr.puts @option_parser
      return false
    end

    contact = @address_book.contact contact_id
    if contact.nil?
      raise "contact '#{contact_id}' not found"
    end

    @address_book.rename_contact(contact, new_id)

    true
  end

end

