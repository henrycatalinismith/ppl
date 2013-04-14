
class Ppl::Application::Output

  attr_accessor :stdout
  attr_accessor :stderr

  def initialize(stdout, stderr)
    @stdout = stdout
    @stderr = stderr
  end

  def error(string)
    @stderr.puts sanitise(string)
  end

  def line(string)
    @stdout.puts sanitise(string)
    true
  end

  private

  def sanitise(string)
    string.delete "\r"
  end

end

