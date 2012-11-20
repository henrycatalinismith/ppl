
class Ppl::Application::Shell

  attr_writer :router

  def run(input)
    outcome = false
    begin
      command = select_command(input)
      outcome = execute_command(command, input)
    rescue
      outcome = false
    end
    return outcome
  end


  private

  def select_command(input)
    @router.route(input.arguments.first)
  end

  def execute_command(command, input)
    command.execute
  end

end

