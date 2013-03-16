
class Ppl::Command::Email < Ppl::Command::Attribute

  name        "email"
  description "Show or change a contact's email address"

  def initialize
    @attribute = :email_addresses
  end

  def options(parser, options)
    parser.banner = "usage: ppl email <contact> [<email-address>]"
    parser.on("-d", "--delete", "delete email address") do
      options[:delete] = true
    end
  end

end

