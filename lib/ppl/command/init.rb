
class Ppl::Command::Init < Ppl::Command

  def name
    "init"
  end

  def summary
    "Create an empty ppl repository"
  end

  def banner
    "Usage: ppl init [directory]"
  end

  def options(parser)
  end

  def execute(argv, options)

    commit_message = argv.dup

    directory = argv.shift || Dir.pwd
    directory = File.expand_path directory

    git_repo  = File.join directory, ".git"
    ppl_repo  = File.join directory, ".ppl"

    if !File.exists? directory
      FileUtils.mkdir_p directory
    end

    if !File.exists? git_repo
      Rugged::Repository.init_at directory, false
    end

    if !File.exists? ppl_repo
      FileUtils.mkdir_p ppl_repo
    end

    repository   = Rugged::Repository.new directory
    address_book = Ppl::Address_Book.new repository
    address_book.commit commit_message

    puts "Initialized empty ppl repository in #{directory}"

    true
  end

end

