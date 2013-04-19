
require "readline"

class Ppl::Command::Scrape < Ppl::Application::Command

  name        "scrape"
  description "Scrape contact details from stdin"

  attr_writer :email_scraper

  def options(parser, options)
    parser.banner = "usage: ppl scrape [<options>]"
    parser.on("-q", "--quiet", "Add contacts to the address book without prompting") do |i|
      options[:quiet] = i
    end
    parser.on("-s", "--sender", "Scrape the sender's contact details") do |i|
      options[:sender] = i
    end
  end

  def execute(input, output)
    contacts = scrape_email(input)
    contacts.each do |contact|
      if store_contact?(contact, input)
        @storage.save_contact(contact)
      end
    end
    return true
  end

  private

  def scrape_email(input)
    ARGV.shift
    email = input.stdin.read
    contacts = []
    if input.options[:sender]
      contacts |= scrape_sender(email)
    end
    contacts
  end

  def scrape_sender(email)
    @email_scraper.scrape_contacts(email)
  end

  def store_contact?(contact, input)
    if input.options[:quiet]
      true
    else
      input.stdin.reopen("/dev/tty", "r") if input.stdin.eof?
      message = generate_prompt_string(contact)
      Readline.readline(message).downcase != "n"
    end
  end

  def generate_prompt_string(contact)
    sprintf('Add "%s <%s>" to your address book [Y/n]? ',
      contact.name,
      contact.email_addresses.first
    )
  end

end

