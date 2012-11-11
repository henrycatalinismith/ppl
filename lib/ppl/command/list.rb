
class Ppl::Command::List < Ppl::Command::Base

  def name
    "list"
  end

  def summary
    "Show a list of all contacts"
  end

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

