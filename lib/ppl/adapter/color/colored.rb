
require "colored"

class Ppl::Adapter::Color::Colored

  def colorize(string, color)
    if Colored::COLORS[color].nil?
      string
    else
      string.send(color)
    end
  end

end

