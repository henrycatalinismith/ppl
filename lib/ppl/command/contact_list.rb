
class Ppl::Command::List < Ppl::Command

  @@default_colors = {
    :contact => "blue",
    :name    => "green",
    :email   => "yellow",
  }

  def name
    "contact:list"
  end

  def summary
    "Show a list of all contacts"
  end

  def banner
    "Usage: ppl contact:list"
  end

  def options(parser)
  end

  def execute(argv, options)
    @address_book.each do |contact|
      output({
        :contact => sprintf("%-10s", contact.id + ":"),
        :name    => sprintf("%s ", contact.name),
        :email   => sprintf("%-20s", "<" + contact.email + ">"),
      })
    end
    return true
  end

end

