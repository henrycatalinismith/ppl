

module Ppl

  class App

    def run
      puts ARGV
      cmd = Ppl::Commands::List.new
    end

  end

end

