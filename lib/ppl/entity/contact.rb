
class Ppl::Entity::Contact

  attr_accessor :id
  attr_accessor :name
  attr_accessor :birthday
  attr_accessor :email_addresses
  attr_accessor :nicknames
  attr_accessor :organizations
  attr_accessor :phone_numbers
  attr_accessor :postal_addresses

  def initialize
    @email_addresses  = []
    @nicknames        = []
    @organizations    = []
    @phone_numbers    = []
    @postal_addresses = []
  end

end

