
class Ppl::Command::AddressBookInit < Ppl::Application::Command

  def initialize
    @name        = "init"
    @description = "Create an empty address book"
  end

  def execute(input, output)

    path = input.arguments.shift

    return true
  end

end

