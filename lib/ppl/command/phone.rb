
class Ppl::Command::Phone < Ppl::Command::Attribute

  name        "phone"
  description "List, show or change phone numbers"

  def initialize
    @attribute = :phone_numbers
  end

  def options(parser, options)
    parser.banner = "usage: ppl phone <contact> [<number>]"
    parser.on("-d", "--delete", "delete phone number") do
      options[:delete] = true
    end
  end

end

