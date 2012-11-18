
require "active_support/core_ext/time/calculations.rb"

class Ppl::Entity::Contact < Ppl::Entity

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

  def set_email(address, location = nil, preferred = nil)
    @vcard.delete_if { |line|
      line.name == "EMAIL" && line.value == address
    }
    @vcard.make do |maker|
      maker.add_email(address) do |email|
        email.location  = location
        email.preferred = preferred
      end
    end
  end

  def set_phone(number, location = nil, preferred = nil)
    @vcard.delete_if { |line|
      line.name == "TEL" && line.value == number
    }
    @vcard.make do |maker|
      maker.add_tel(number) do |tel|
        tel.location  = location
        tel.preferred = preferred
      end
    end
  end

  def set_address(location, address)
    @vcard.delete_if { |line|
      line.name == "ADR" && line.value.location.first == location
    }
    @vcard.make do |maker|
      maker.add_addr do |addr|
        addr.location = location
        if !address[:country].nil?
          addr.country = address[:country]
        end
        if !address[:city].nil?
          addr.locality = address[:city]
        end
        if !address[:postalcode].nil?
          addr.postalcode = address[:postalcode]
        end
        if !address[:region].nil?
          addr.region = address[:region]
        end
        if !address[:street].nil?
          addr.street = address[:street]
        end
      end
    end
  end

  def set_name(options)
    @vcard.make do |maker|
      maker.name do |name|
        if !options[:given].nil?
          name.given = options[:given]
        end
        if !options[:surname].nil?
          name.family = options[:surname]
        end
        if !options[:prefix].nil?
          name.prefix = options[:prefix]
        end
        if !options[:suffix].nil?
          name.suffix = options[:suffix]
        end
      end
    end
  end

end

