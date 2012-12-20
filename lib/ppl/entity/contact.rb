
class Ppl::Entity::Contact

  attr_accessor :id
  attr_accessor :name
  attr_accessor :email_address
  attr_accessor :birthday
  attr_accessor :phone_number
  attr_accessor :organization
  attr_accessor :postal_address

  def initialize
    @postal_address = Ppl::Entity::PostalAddress.new
  end

  def set_postal_address
    yield @postal_address
  end

end

