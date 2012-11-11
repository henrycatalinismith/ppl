
require "ppl/command/base"

class Ppl::Command::Show < Ppl::Command::Base

  def name
    "show"
  end

  def summary
    "Show full details of a single contact"
  end

  def index
    vcard = load_vcard @arguments.first

    puts vcard.name.fullname.yellow

    vcard.emails.each do |email|
      puts email.blue
    end

  end

end

