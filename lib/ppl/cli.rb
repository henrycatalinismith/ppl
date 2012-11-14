
require "ppl"
require "optparse"
require "optparse/date"

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
      constant = Ppl::Command.const_get(name)
      @commands.push constant.new
    end
    @commands.sort! { |a,b| a.name <=> b.name }

    @commands.each do |command|
      command.address_book  = @address_book
      command.commands      = @commands
    end
  end

  def find_command(name)
    matches = @commands.select { |command| command.name == name }
    matches.first
  end


end

