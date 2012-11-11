
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

    @address_book.with_birthday.each do |contact|

      birthday = contact.birthday.dup
      while birthday < today
        birthday = birthday.advance :years => 1
      end
      days = birthday - today

      puts(
        sprintf("%-20s", contact.id)       +
        sprintf("%-20s", contact.name)     +
        sprintf("%-20s", contact.birthday) +
        sprintf("%d days", days)
      )

    end

  end

end

