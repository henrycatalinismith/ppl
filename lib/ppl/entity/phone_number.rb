class Ppl::Entity::PhoneNumber

  attr_accessor :number
  attr_accessor :type
  attr_accessor :preferred

  def initialize(number = nil, type = nil)
    @number = number
    @preferred = false
    @type = type
  end

end

