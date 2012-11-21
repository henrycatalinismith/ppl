
class Ppl::Application::Command

  attr_accessor :name
  attr_accessor :description
  attr_accessor :storage

  def execute(input, output)
    raise NotImplementedError
  end

end

