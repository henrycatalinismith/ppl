
require "active_support/core_ext/time/calculations.rb"
require "active_support/core_ext/date_time/calculations.rb"

class Ppl::Command::Birthdays < Ppl::Command::Base

  def name
    "birthdays"
  end

  def summary
    "Show a list of upcoming birthdays"
  end

  def index
    today = Date.today

    @address_book.each do |id, vcard|
      if vcard.birthday.nil?
        next
      end

      birthday = vcard.birthday.dup

      while birthday < today
        birthday = birthday.advance :years => 1
      end

      days = birthday - today

      puts(
        sprintf("%-20s", id)                  +
        sprintf("%-20s", vcard.name.fullname) +
        sprintf("%-20s", vcard.birthday)      +
        sprintf("%d days", days)
      )

    end

  end

end

