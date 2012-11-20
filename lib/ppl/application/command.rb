
class Ppl::Application::Command

  attr_accessor :name
  attr_accessor :description

  def execute(input, output)
    raise NotImplementedError
  end

end

