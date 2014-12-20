
class Ppl::Entity::EmailAddress

  attr_accessor :address
  attr_accessor :preferred

  def initialize(address = nil)
    @address = address
    @preferred = false
  end

  def to_s()
    return @address
  end

end

