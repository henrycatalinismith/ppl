
class Ppl::Command::SetPhone < Ppl::Command

  def name
    "phone"
  end

  def summary
    "Set a contact's phone number"
  end

  def banner
    "Usage: ppl phone <contact> <number>"
  end

  def commit_on_success
    true
  end

  def options(parser)
    parser.on("--location <location>", "Location, e.g. 'home' or 'work'") do |location|
      @options[:location] = location
    end
    parser.on("--preferred", "Make this the preferred number for this contact") do |preferred|
      @options[:preferred] = preferred
    end
  end

  def execute(argv, options)

    contact_id = argv.shift
    number     = argv.shift

    if contact_id.nil? || number.nil?
      $stderr.puts @option_parser
      return false
    end

    contact = @address_book.contact contact_id
    if contact.nil?
      raise "contact '#{contact_id}' not found"
    end

    contact.set_phone(number, options[:location], options[:preferred])
    @address_book.save_contact contact
    true
  end

end

