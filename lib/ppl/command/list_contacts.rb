
class Ppl::Command::ListContacts < Ppl::Application::Command

  def initialize
    @name        = "ls"
    @description = "List all contacts"
  end

end

