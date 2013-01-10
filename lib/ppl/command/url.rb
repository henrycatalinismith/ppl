
class Ppl::Command::Url < Ppl::Command::Attribute

  name        "url"
  description "List, show or change URLs"

  def initialize
    @attribute   = :urls
    @show_format = Ppl::Format::Contact::Urls.new
    @list_format = Ppl::Format::AddressBook::Urls.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl url <contact> [<url>]"
    parser.on("-d", "--delete", "delete url") do
      options[:delete] = true
    end
  end

end

