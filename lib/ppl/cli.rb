
require "ppl"
require "optparse"

class Ppl::CLI

  def initialize
    @address_book = Ppl::Address_Book.new("/home/h2s/doc/contacts")
    @commands     = commands

    find_command("help").commands = @commands
  end

  def run(argv)
    command_name = argv.shift
    command      = find_command command_name

    if command.nil?
      command = find_command "help"
    end

    command.run argv
  end

  private

  def commands
    @commands = []
    Ppl::Command.constants.each do |name|
      optparse = OptionParser.new
      constant = Ppl::Command.const_get(name)
      command = constant.new(@address_book, optparse)
      @commands.push command
    end
    @commands.sort! { |a,b| a.name <=> b.name }
  end

  def find_command(name)
    matches = @commands.select { |command| command.name == name }
    matches.first
  end

end

