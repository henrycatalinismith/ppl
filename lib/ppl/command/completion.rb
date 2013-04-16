
class Ppl::Command::Completion < Ppl::Application::Command

  name        "completion"
  description "Output shell completion function"

  def options(parser, options)
    parser.banner = "usage: ppl completion <shell>"
  end

  def execute(input, output)
    shell = input.arguments.shift
    if shell.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end
    return true
  end

end

