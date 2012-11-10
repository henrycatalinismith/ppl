
require "vpim/vcard"
require "colored"

class Ppl::Command::List < Ppl::Command::Base

  def index

    pattern  = @options[:path] + "/*.vcard"
    contacts = Dir.glob pattern

    contacts.each do |filename|

      id = File.basename(filename).slice(0..-7)

      vcard = IO.read filename
      vcard = Vpim::Vcard.decode(vcard).first

      puts(
        sprintf("%-20s", id).red +
        sprintf("%-20s", vcard.name.fullname).yellow +
        sprintf("%-20s", vcard.email).blue
      )

    end

  end

end

