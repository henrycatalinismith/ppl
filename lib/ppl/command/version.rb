class Ppl::Command::Version < Ppl::Application::Command

  name        "version"
  description "Display ppl version information"

  attr_writer :format

  def options(parser, options)
    parser.banner = "usage: ppl version"
  end

  def execute(input, output)
    output.line("ppl version #{Ppl::Version}")
    true
  end

end

