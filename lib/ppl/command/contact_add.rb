
class Ppl::Command::ContactAdd < Ppl::Application::Command

  def initialize
    @name        = "add"
    @description = "Add a new contact"
  end

  def execute(input, output)
    return true
  end

end

