
class Ppl::Command::Rm < Ppl::Command

  def name
    "rm"
  end

  def summary
    "Delete a contact"
  end

  def banner
    "Usage: ppl rm <contact>"
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

    @address_book.delete_contact contact_id

  end

end

