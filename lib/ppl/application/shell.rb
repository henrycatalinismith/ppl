
class Ppl::Application::Shell

  attr_writer :router

  def run(input)

    command = select_command(input)
    if command.nil?
      return false
    end

    execute_command(command, input)

  end


  private

  def select_command(input)
    @router.route(input.arguments.first)
  end

  def execute_command(command, input)
    command.execute
  end

end

