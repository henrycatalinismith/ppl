
class Ppl::Command::ContactList < Ppl::Application::Command

  def initialize
    @name        = "ls"
    @description = "List all contacts"
  end

  def execute(input, output)
    return true
  end

end

