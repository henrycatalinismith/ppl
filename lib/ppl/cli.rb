
require "ppl"
require "optparse"
require "optparse/date"
require "rugged"
require "fileutils"

class Ppl::CLI

  def initialize
    @config = Ppl::Configuration.new

    if !File.exists? @config["address_book"]["path"]
      $stderr.puts "ppl: #{@config["address_book"]["path"]} does not exist, creating"
      FileUtils.mkdir_p @config["address_book"]["path"]
    end

    @repository   = Rugged::Repository.new @config["address_book"]["path"]
    @address_book = Ppl::Address_Book.new(@config["address_book"]["path"], @repository)
    @commands     = commands

  end

  def run(argv)

    command_name = argv.shift
    alias_match  = @config["alias"][command_name]

    if !alias_match.nil?
      alias_match.split.reverse.each do |piece|
        argv.unshift piece
      end
      command_name = argv.shift
    end

    command = find_command command_name

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

