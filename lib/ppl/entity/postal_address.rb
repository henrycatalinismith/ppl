
class Ppl::Entity::PostalAddress

  attr_accessor :id
  attr_accessor :preferred
  attr_accessor :country
  attr_accessor :locality
  attr_accessor :street
  attr_accessor :po_box
  attr_accessor :postal_code
  attr_accessor :region

  def initialize
    @preferred = false
  end

end

