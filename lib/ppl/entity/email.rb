
class Ppl::Entity::Email

  attr_accessor :address
  attr_accessor :location
  attr_accessor :preferred

  def initialize
    @preferred = false
  end

end

