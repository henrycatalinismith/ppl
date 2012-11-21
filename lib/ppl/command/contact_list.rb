
class Ppl::Command::ContactList < Ppl::Application::Command

  def initialize
    @name        = "ls"
    @description = "List all contacts"
  end

  def execute(input, output)
    address_book = @storage.load_address_book

    address_book.each do |contact|
      puts contact
    end

    return true
  end

end

