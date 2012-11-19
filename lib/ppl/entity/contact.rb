
class Ppl::Entity::Contact

  attr_accessor :email_addresses
  attr_accessor :postal_addresses
  attr_accessor :phone_numbers

  def initialize
    @email_addresses  = []
    @postal_addresses = []
    @phone_numbers    = []
  end

end

