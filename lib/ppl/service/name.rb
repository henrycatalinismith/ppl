
class Ppl::Service::Name

  def parse(full_name)
    parts = full_name.split " "
    name = Ppl::Entity::Name.new
    name.full = full_name
    name.given = parts.shift unless parts[0].nil?
    name.family = parts.join(" ") unless parts[0].nil?
    name
  end

  def update(name, new_values)
    [:full, :given, :family, :middle, :prefix, :suffix].each do |property_name|
      if !new_values[property_name].nil?
        setter = (property_name.to_s + "=").to_sym
        name.send(setter, new_values[property_name])
      end
    end
  end

end

