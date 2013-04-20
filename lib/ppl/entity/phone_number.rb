
class Ppl::Entity::PhoneNumber

  attr_accessor :number
  attr_accessor :type

  def initialize(number = nil, type = nil)
    @number = number
    @type = type
  end

end

