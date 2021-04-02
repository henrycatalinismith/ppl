class Ppl::Command::Org < Ppl::Command::Attribute

  name        "org"
  description "List, show or change organizations"

  def initialize
    @attribute = :organizations
  end

  def options(parser, options)
    parser.banner = "usage: ppl org <contact> [<organization>]"
    parser.on("-d", "--delete", "delete organization") do
      options[:delete] = true
    end
  end

end

