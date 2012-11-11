
require "ppl/command/base"

class Ppl::Command::Show < Ppl::Command::Base

  def name
    "show"
  end

  def summary
    "Show full details of a single contact"
  end

  def index
    contact = @address_book.contact @arguments.first

    puts contact.name.yellow
    contact.emails.each do |email|
      puts email.blue
    end

  end

end

