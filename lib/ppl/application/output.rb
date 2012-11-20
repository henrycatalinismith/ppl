
class Ppl::Application::Output

  attr_accessor :stdout
  attr_accessor :stderr

  def initialize(stdout, stderr)
    @stdout = stdout
    @stderr = stderr
  end

end

