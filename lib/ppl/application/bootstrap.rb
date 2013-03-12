
require "morphine"

class Ppl::Application::Bootstrap

  include Morphine

  register :command_add do
    add = Ppl::Command::Add.new
    add.storage = storage_adapter
    add
  end

  register :command_age do
    age = Ppl::Command::Age.new
    age.storage = storage_adapter
    age.list_format = format_address_book_ages
    age.show_format = format_contact_age
    age
  end

  register :command_bday do
    bday = Ppl::Command::Bday.new
    bday.storage = storage_adapter
    bday.list_format = format_address_book_birthdays
    bday.show_format = format_contact_birthday
    bday
  end

  register :command_email do
    email = Ppl::Command::Email.new
    email.storage = storage_adapter
    email.list_format = format_address_book_email_addresses
    email.show_format = format_contact_email_addresses
    email
  end

  register :command_help do
    help = Ppl::Command::Help.new
    help.storage = storage_adapter
    help
  end

  register :command_init do
    init = Ppl::Command::Init.new
    init.storage = storage_adapter
    init
  end

  register :command_ls do
    ls = Ppl::Command::Ls.new
    ls.storage = storage_adapter
    ls.format = format_address_book_one_line
    ls
  end

  register :command_mutt do
    mutt = Ppl::Command::Mutt.new
    mutt.storage = storage_adapter
    mutt.format = format_address_book_mutt_query
    mutt
  end

  register :command_mv do
    mv = Ppl::Command::Mv.new
    mv.storage = storage_adapter
    mv
  end

  register :command_name do
    name = Ppl::Command::Name.new
    name.storage = storage_adapter
    name.list_format = format_address_book_names
    name.show_format = format_contact_name
    name
  end

  register :command_nick do
    nick = Ppl::Command::Nick.new
    nick.storage = storage_adapter
    nick.list_format = format_address_book_nicknames
    nick.show_format = format_contact_nicknames
    nick
  end

  register :command_org do
    org = Ppl::Command::Org.new
    org.list_format = format_address_book_organizations
    org.show_format = format_contact_organizations
    org.storage = storage_adapter
    org
  end

  register :command_phone do
    phone = Ppl::Command::Phone.new
    phone.storage = storage_adapter
    phone.list_format = format_address_book_phone_numbers
    phone.show_format = format_contact_phone_numbers
    phone
  end

  register :command_post do
    post = Ppl::Command::Post.new
    post.storage = storage_adapter
    post.list_format = format_address_book_postal_addresses
    post.show_format = format_contact_postal_addresses
    post
  end

  register :command_pull do
    pull = Ppl::Command::Execute.new("pull", "git pull", "Execute 'git pull' in the address book directory")
    pull.storage = storage_adapter
    pull
  end

  register :command_push do
    push = Ppl::Command::Execute.new("push", "git push", "Execute 'git push' in the address book directory")
    push.storage = storage_adapter
    push
  end

  register :command_remote do
    remote = Ppl::Command::Execute.new("remote", "git remote", "Execute 'git remote' in the address book directory")
    remote.storage = storage_adapter
    remote
  end

  register :command_rm do
    rm = Ppl::Command::Rm.new
    rm.storage = storage_adapter
    rm
  end

  register :command_shell do
    shell = Ppl::Command::Shell.new
    shell.storage = storage_adapter
    shell
  end

  register :command_show do
    show = Ppl::Command::Show.new
    show.storage = storage_adapter
    show
  end

  register :command_url do
    url = Ppl::Command::Url.new
    url.storage = storage_adapter
    url.list_format = format_address_book_urls
    url.show_format = format_contact_urls
    url
  end

  register :command_version do
    version = Ppl::Command::Version.new
    version.storage = storage_adapter
    version
  end

  register :command_suite do
    suite = Ppl::Application::CommandSuite.new
    suite.add_command command_add
    suite.add_command command_age
    suite.add_command command_bday
    suite.add_command command_email
    suite.add_command command_help
    suite.add_command command_init
    suite.add_command command_ls
    suite.add_command command_mutt
    suite.add_command command_mv
    suite.add_command command_name
    suite.add_command command_nick
    suite.add_command command_org
    suite.add_command command_phone
    suite.add_command command_post
    suite.add_command command_pull
    suite.add_command command_push
    suite.add_command command_remote
    suite.add_command command_rm
    suite.add_command command_shell
    suite.add_command command_show
    suite.add_command command_url
    suite.add_command command_version
    suite.find_command("help").command_suite = suite
    suite
  end

  register :configuration do
    Ppl::Application::Configuration.new
  end

  register :execute_command do
    command = Ppl::Command::Execute.new(nil, nil, nil)
    command.storage = storage_adapter
    command
  end

  register :format_address_book_ages do
    config = configuration
    colors = config.color_enabled("age") ? config.command_colors("age") : {}
    Ppl::Format::AddressBook::Ages.new(colors)
  end

  register :format_address_book_birthdays do
    config = configuration
    colors = config.color_enabled("bday") ? config.command_colors("bday") : {}
    Ppl::Format::AddressBook::Birthdays.new(colors)
  end

  register :format_address_book_email_addresses do
    config = configuration
    colors = config.color_enabled("email") ? config.command_colors("email") : {}
    Ppl::Format::AddressBook::EmailAddresses.new(colors)
  end

  register :format_address_book_mutt_query do
    Ppl::Format::AddressBook::MuttQuery.new
  end

  register :format_address_book_names do
    config = configuration
    colors = config.color_enabled("name") ? config.command_colors("name") : {}
    Ppl::Format::AddressBook::Names.new(colors)
  end

  register :format_address_book_nicknames do
    config = configuration
    colors = config.color_enabled("nick") ? config.command_colors("nick") : {}
    Ppl::Format::AddressBook::Nicknames.new(colors)
  end

  register :format_address_book_one_line do
    config = configuration
    colors = config.color_enabled("ls") ? config.command_colors("ls") : {}
    Ppl::Format::AddressBook::OneLine.new(colors)
  end

  register :format_address_book_organizations do
    config = configuration
    colors = config.color_enabled("org") ? config.command_colors("org") : {}
    Ppl::Format::AddressBook::Organizations.new(colors)
  end

  register :format_address_book_phone_numbers do
    config = configuration
    colors = config.color_enabled("phone") ? config.command_colors("phone") : {}
    Ppl::Format::AddressBook::PhoneNumbers.new(colors)
  end

  register :format_address_book_postal_addresses do
    config = configuration
    colors = config.color_enabled("post") ? config.command_colors("post") : {}
    Ppl::Format::AddressBook::PostalAddresses.new(colors)
  end

  register :format_address_book_urls do
    config = configuration
    colors = config.color_enabled("url") ? config.command_colors("url") : {}
    Ppl::Format::AddressBook::Urls.new(colors)
  end

  register :format_contact_age do
    config = configuration
    colors = config.color_enabled("age") ? config.command_colors("age") : {}
    Ppl::Format::Contact::Age.new(colors)
  end

  register :format_contact_birthday do
    Ppl::Format::Contact::Birthday.new
  end

  register :format_contact_email_addresses do
    Ppl::Format::Contact::EmailAddresses.new
  end

  register :format_contact_name do
    Ppl::Format::Contact::Name.new
  end

  register :format_contact_nicknames do
    Ppl::Format::Contact::Nicknames.new
  end

  register :format_contact_organizations do
    Ppl::Format::Contact::Organization.new
  end

  register :format_contact_phone_numbers do
    Ppl::Format::Contact::PhoneNumber.new
  end

  register :format_contact_postal_addresses do
    Ppl::Format::Contact::PostalAddress.new
  end

  register :format_contact_urls do
    Ppl::Format::Contact::Urls.new
  end

  register :input do
    Ppl::Application::Input.new(ARGV.dup)
  end

  register :output do
    Ppl::Application::Output.new($stdout, $stderr)
  end

  register :router do
    router = Ppl::Application::Router.new(command_suite)
    router.aliases = configuration.aliases
    router.default = "help"
    router.execute_command = execute_command
    router
  end

  register :shell do
    shell = Ppl::Application::Shell.new
    shell.router = router
    shell
  end

  register :storage_adapter do
    config = configuration
    directory = Dir.new(config.address_book_path)
    factory   = Ppl::Adapter::Storage::Factory.new(vcard_adapter)
    storage   = factory.load_adapter(directory)
    storage.vcard_adapter = vcard_adapter
    storage
  end

  register :vcard_adapter do
    Ppl::Adapter::Vcard::Vpim.new
  end

end

