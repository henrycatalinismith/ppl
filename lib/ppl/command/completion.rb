
class Ppl::Command::Completion < Ppl::Application::Command

  name        "completion"
  description "Output shell completion function"

  attr_writer :completions_directory

  def options(parser, options)
    parser.banner = "usage: ppl completion <shell>"
  end

  def execute(input, output)
    shell = input.arguments.shift
    if shell.nil?
      raise Ppl::Error::IncorrectUsage, "No contact specified"
    end

    path = File.join(@completions_directory.path, shell)
    if !File.exists? path
      raise Ppl::Error::CompletionNotFound, shell
    end

    output.line(File.read(path))
  end

end

