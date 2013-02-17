
class Ppl::Command::Execute < Ppl::Application::Command

  def initialize(name, command)
    @name = name
    @command = command
  end

  def execute(input, output)
    if !input.arguments.empty?
      @command += " " + input.arguments.join(" ")
    end
    Dir.chdir(@storage.path)
    Kernel.exec(@command)
  end

end

