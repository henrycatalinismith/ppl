
class Ppl::Command::SetName < Ppl::Command

  def name
    "set:name"
  end

  def summary
    "Set a contact's name"
  end

  def banner
    "Usage: ppl set:name <contact> [options]"
  end

  def commit_on_success
    true
  end

  def options(parser)
    parser.on("--given <given>", "Given name or first name") do |given|
      @options[:given] = given
    end
    parser.on("--surname <surname>", "Surname or family name") do |surname|
      @options[:surname] = surname
    end
    parser.on("--prefix <prefix>", "Prefix, e.g. 'Mrs.' or 'Dr.'") do |prefix|
      @options[:prefix] = prefix
    end
    parser.on("--suffix <suffix>", "Suffix, e.g. 'PhD'") do |suffix|
      @options[:suffix] = suffix
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

    false
  end

end

