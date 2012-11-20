
class Ppl::Application::Output

  attr_accessor :stdout
  attr_accessor :stderr

  def initialize(stdout, stderr)
    @stdout = stdout
    @stderr = stderr
  end

  def error(string)
    @stderr.puts string
  end

  def line(string)
    @stdout.puts string
  end

end

