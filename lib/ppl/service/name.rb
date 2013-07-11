
class Ppl::Service::Name

  def parse(full_name)
    parts = full_name.split " "
    name = Ppl::Entity::Name.new
    name.full = full_name
    name.given = parts.shift unless parts[0].nil?
    name.family = parts.join(" ") unless parts[0].nil?
    name
  end

end

