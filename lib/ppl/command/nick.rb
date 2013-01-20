
class Ppl::Command::Nick < Ppl::Command::Attribute

  name        "nick"
  description "List, show or change nicknames"

  def initialize
    @attribute   = :nicknames
    @show_format = Ppl::Format::Contact::Urls.new
    @list_format = Ppl::Format::AddressBook::Nicknames.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl nick <contact> [<nickname>]"
    parser.on("-d", "--delete", "delete nickname") do
      options[:delete] = true
    end
  end

end

