
class Ppl::Command::ContactAdd < Ppl::Application::Command

  def initialize
    @name        = "add"
    @description = "Add a new contact"
  end

  def execute(input, output)
    contact_id = input.arguments.shift
    full_name  = input.arguments.shift

    if contact_id.nil? || full_name.nil?
      raise Ppl::Error::IncorrectUsage
    end

    return true
  end

end

