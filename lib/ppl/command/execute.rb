
class Ppl::Command::Execute < Ppl::Application::Command

  attr_writer :command

  def execute(input, output)
    Dir.chdir(@storage.path)
    Kernel.exec(@command)
  end

end

