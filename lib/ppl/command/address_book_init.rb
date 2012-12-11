
class Ppl::Command::AddressBookInit < Ppl::Application::Command

  def initialize
    @name        = "init"
    @description = "Create an empty address book"
  end

  def execute(input, output)

    path = input.arguments.shift
    if path.nil?
      path = Dir.pwd
    end

    storage = Ppl::Adapter::Storage::Git.create_address_book(path)

    return true
  end

end

