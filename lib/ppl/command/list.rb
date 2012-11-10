
class Ppl::Command::List < Ppl::Command::Base

  def index

    vcards = all_vcards

    vcards.each do |id, vcard|

      puts(
        sprintf("%-20s", id).red +
        sprintf("%-20s", vcard.name.fullname).yellow +
        sprintf("%-20s", vcard.email).blue
      )

    end

  end

end

