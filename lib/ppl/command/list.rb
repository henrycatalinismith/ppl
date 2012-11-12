
class Ppl::Command::List < Ppl::Command

  def name
    "list"
  end

  def summary
    "Show a list of all contacts"
  end

  def index
    @address_book.each do |contact|
      puts(
        sprintf("%-10s", contact.id + ":") +
        sprintf("%s ", contact.name)   +
        sprintf("%-20s", "<" + contact.email + ">")
      )
    end
  end

end

