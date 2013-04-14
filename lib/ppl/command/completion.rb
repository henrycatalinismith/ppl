
class Ppl::Command::Completion < Ppl::Application::Command

  name        "completion"
  description "Output shell completion function"

  def options(parser, options)
    parser.banner = "usage: ppl completion <shell>"
  end

  def execute(input, output)
    return true
  end

end

