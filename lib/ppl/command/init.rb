
class Ppl::Command::Init < Ppl::Application::Command

  name        "init"
  description "Create an empty address book"

  def options(parser, options)
    parser.banner = "usage: ppl init [directory]"
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

