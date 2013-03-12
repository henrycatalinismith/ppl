
class Ppl::Format::Contact::Age < Ppl::Format::Contact

  attr_writer :color_adapter
  attr_writer :colors

  def initialize(colors={})
    @colors = colors
    @color_adapter = Ppl::Adapter::Color::Colored.new
  end

  def process(contact)
    age = contact.age(Date.today).to_s
    if @colors["age"]
      age = @color_adapter.colorize(age, @colors["age"])
    end
    age
  end

end

