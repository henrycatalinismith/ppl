
class Ppl::Command::Set < Ppl::Command

  def name
    "set"
  end

  def summary
    "Change the details of a contact"
  end

  def banner
    "Usage: ppl set <contact> [options]"
  end

  def options(parser)
    parser.on("-e", "--email <email>", "Email address") do |email|
      @options[:email] = email
    end
    parser.on("-b", "--birthday <date>", "Birthday") do |birthday|
      @options[:birthday] = Date.parse birthday
    end
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

    if !options[:email].nil?
      contact.email = options[:email]
    end

    if !options[:birthday].nil?
      contact.birthday = options[:birthday]
    end

    @address_book.save_contact contact
  end

end

