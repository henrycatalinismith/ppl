
class Ppl::Entity::Contact

  attr_accessor :id
  attr_accessor :name
  attr_accessor :email_address
  attr_accessor :birthday
  attr_accessor :phone_number
  attr_accessor :organization
  attr_accessor :postal_address

  def set_postal_address
    @postal_address = Ppl::Entity::PostalAddress.new
    yield @postal_address
  end

end

