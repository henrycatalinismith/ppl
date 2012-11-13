
require "active_support/core_ext/time/calculations.rb"

class Ppl::Contact

  attr_reader :id
  attr_reader :vcard

  def initialize(id, vcard)
    @id    = id
    @vcard = vcard
  end

  def birthday
    @vcard.birthday
  end

  def until_birthday(now)
    birthday = self.birthday.dup
    while birthday < now
      birthday = birthday.advance :years => 1
    end
    birthday - now
  end

  def email
    @vcard.emails.first
  end

  def emails
    @vcard.emails
  end

  def name
    @vcard.name.fullname
  end

  def to_s
    @vcard.to_s
  end

  def birthday=(date)
    @vcard.make do |maker|
      maker.birthday = date
    end
  end

  def email=(address)
    @vcard.delete_if { |line|
      line.name == "EMAIL" && line.value == address
    }
    @vcard.make do |maker|
      maker.add_email(address)
    end
  end

end

