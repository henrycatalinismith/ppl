
class Ppl::Service::Name

  def parse(full_name)
    name = Ppl::Entity::Name.new
    name.full = full_name
    name
  end

end

