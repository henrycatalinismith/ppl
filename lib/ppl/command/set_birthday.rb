
class Ppl::Command::SetBirthday < Ppl::Command

  def name
    "bday"
  end

  def summary
    "Set a contact's birthday"
  end

  def banner
    "Usage: ppl birthday <contact> <date>"
  end

  def commit_on_success
    true
  end

  def options(parser)
  end

  def execute(argv, options)

    contact_id = argv.shift
    birthday   = argv.shift

    if contact_id.nil? || birthday.nil?
      $stderr.puts @option_parser
      return false
    end

    contact = @address_book.contact contact_id
    if contact.nil?
      raise "contact '#{contact_id}' not found"
    end

    begin
      birthday = Date.parse birthday
    rescue ArgumentError
      $stderr.puts "ppl: Invalid date '#{birthday}'"
      $stderr.puts @option_parser
      return false
    end

    contact.birthday = birthday
    @address_book.save_contact contact
    true
  end

end

