
class Ppl::Entity::Name
  attr_accessor :full
  attr_accessor :family
  attr_accessor :given
  attr_accessor :middle
  attr_accessor :prefix
  attr_accessor :suffix

  def to_s
    @full
  end
end

