
class Ppl::Command::List < Ppl::Command

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

      line  = ""
      line += sprintf("%-10s", contact.id + ":")
      line += sprintf("%s ", contact.name)

      if !contact.email.nil?
        line += sprintf("%-20s", "<" + contact.email + ">")
      end

      puts line
    end
    return true
  end

end

