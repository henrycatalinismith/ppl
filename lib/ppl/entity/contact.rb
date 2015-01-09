
class Ppl::Entity::Contact

  attr_accessor :id
  attr_accessor :name
  attr_accessor :nicknames
  attr_accessor :email_addresses
  attr_accessor :birthday
  attr_accessor :phone_numbers
  attr_accessor :organizations
  attr_accessor :postal_address
  attr_accessor :postal_addresses
  attr_accessor :urls

  # The greencard adapter needs this attribute to restore all unknown fields.
  attr_accessor :vcard

  def initialize
    @email_addresses = []
    @nicknames = []
    @organizations = []
    @phone_numbers = []
    @postal_addresses = []
    @urls = []
  end

  def set_postal_address
    if @postal_address.nil?
      @postal_address = Ppl::Entity::PostalAddress.new
    end
    yield @postal_address
  end

  def age(on_date)
    if @birthday.nil?
      nil
    else
      # From http://stackoverflow.com/a/2357790
      on_date.year - @birthday.year - ((on_date.month > @birthday.month || (on_date.month == @birthday.month && on_date.day >= @birthday.day)) ? 0 : 1)
    end
  end

  def preferred_email_address
    @email_addresses.find { |e| e.preferred }
  end

  def preferred_phone_number
    @phone_numbers.find { |p| p.preferred }
  end

end

