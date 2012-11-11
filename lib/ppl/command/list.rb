
class Ppl::Command::List < Ppl::Command::Base

  def name
    "list"
  end

  def summary
    "Show a list of all contacts"
  end

  def index
    @address_book.each do |contact|
      puts(
        sprintf("%-20s", contact.id).red +
        sprintf("%-20s", contact.name).yellow +
        sprintf("%-20s", contact.email).blue
      )
    end
  end

end

