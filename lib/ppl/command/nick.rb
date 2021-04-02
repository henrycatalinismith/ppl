class Ppl::Command::Nick < Ppl::Command::Attribute

  name        "nick"
  description "List, show or change nicknames"

  def initialize
    @attribute = :nicknames
  end

  def options(parser, options)
    parser.banner = "usage: ppl nick <contact> [<nickname>]"
    parser.on("-d", "--delete", "delete nickname") do
      options[:delete] = true
    end
    parser.on("--no-color", "turn off colored output") do
      options[:no_color] = true
    end
  end

end

