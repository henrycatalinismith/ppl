
class Ppl::Command::Execute < Ppl::Application::Command

  attr_accessor :command

  def initialize(name, command, description)
    @name = name
    @command = command
    @description = description
  end

  def execute(input, output)
    if !input.arguments.empty?
      @command += " " + input.arguments.join(" ")
    end
    Dir.chdir(@storage.path)
    Kernel.exec(@command)
  end

end

