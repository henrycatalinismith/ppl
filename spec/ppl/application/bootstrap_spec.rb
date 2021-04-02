describe Ppl::Application::Bootstrap do

  before(:each) do
    @bootstrap = Ppl::Application::Bootstrap.new
  end

  describe "#command_add" do
    it "should return a Ppl::Command::Add" do
      expect(@bootstrap.command_add).to be_a(Ppl::Command::Add)
    end
  end

  describe "#command_age" do
    it "should return a Ppl::Command::Age" do
      expect(@bootstrap.command_age).to be_a(Ppl::Command::Age)
    end
  end

  describe "#command_bday" do
    it "should return a Ppl::Command::Bday" do
      expect(@bootstrap.command_bday).to be_a(Ppl::Command::Bday)
    end
  end

  describe "#command_completion" do
    it "should return a Ppl::Command::Completion" do
      expect(@bootstrap.command_completion).to be_a(Ppl::Command::Completion)
    end
    it "should inject a completions directory" do
      allow(Ppl::Command::Completion).to receive(:new) do
        completion = double(Ppl::Command::Completion)
        expect(completion).to receive(:completions_directory=)
        completion
      end
      @bootstrap.command_completion
    end
  end

  describe "#command_email" do
    it "should return a Ppl::Command::Email" do
      expect(@bootstrap.command_email).to be_a(Ppl::Command::Email)
    end
  end

  describe "#command_grep" do
    it "should return a command" do
      expect(@bootstrap.command_grep).to be_a(Ppl::Application::Command)
    end
  end

  describe "#command_help" do
    it "should return a Ppl::Command::Help" do
      expect(@bootstrap.command_help).to be_a(Ppl::Command::Help)
    end
  end

  describe "#command_init" do
    it "should return a Ppl::Command::Init" do
      expect(@bootstrap.command_init).to be_a(Ppl::Command::Init)
    end
  end

  describe "#command_ls" do
    it "should return a Ppl::Command::Ls" do
      expect(@bootstrap.command_ls).to be_a(Ppl::Command::Ls)
    end
  end

  describe "#command_mutt" do
    it "should return a Ppl::Command::Mutt" do
      expect(@bootstrap.command_mutt).to be_a(Ppl::Command::Mutt)
    end
  end

  describe "#command_mv" do
    it "should return a Ppl::Command::Mv" do
      expect(@bootstrap.command_mv).to be_a(Ppl::Command::Mv)
    end
  end

  describe "#command_name" do
    it "should return a Ppl::Command::Name" do
      expect(@bootstrap.command_name).to be_a(Ppl::Command::Name)
    end
  end

  describe "#command_nick" do
    it "should return a Ppl::Command::Nick" do
      expect(@bootstrap.command_nick).to be_a(Ppl::Command::Nick)
    end
  end

  describe "#command_org" do
    it "should return a Ppl::Command::Org" do
      expect(@bootstrap.command_org).to be_a(Ppl::Command::Org)
    end
  end

  describe "#command_phone" do
    it "should return a Ppl::Command::Phone" do
      expect(@bootstrap.command_phone).to be_a(Ppl::Command::Phone)
    end
  end

  describe "#command_post" do
    it "should return a Ppl::Command::Post" do
      expect(@bootstrap.command_post).to be_a(Ppl::Command::Post)
    end
  end

  describe "#command_pull" do
    it "should return a command" do
      expect(@bootstrap.command_pull).to be_a(Ppl::Application::Command)
    end
  end

  describe "#command_push" do
    it "should return a command" do
      expect(@bootstrap.command_push).to be_a(Ppl::Application::Command)
    end
  end

  describe "#command_remote" do
    it "should return a command" do
      expect(@bootstrap.command_remote).to be_a(Ppl::Application::Command)
    end
  end

  describe "#command_rm" do
    it "should return a Ppl::Command::Rm" do
      expect(@bootstrap.command_rm).to be_a(Ppl::Command::Rm)
    end
  end

  describe "#command_scrape" do
    it "should return a Ppl::Command::Scrape" do
      expect(@bootstrap.command_scrape).to be_a(Ppl::Command::Scrape)
    end
  end

  describe "#command_shell" do
    it "should return a Ppl::Command::Shell" do
      expect(@bootstrap.command_shell).to be_a(Ppl::Command::Shell)
    end
  end

  describe "#command_show" do
    it "should return a Ppl::Command::Show" do
      expect(@bootstrap.command_show).to be_a(Ppl::Command::Show)
    end
  end

  describe "#command_url" do
    it "should return a Ppl::Command::Url" do
      expect(@bootstrap.command_url).to be_a(Ppl::Command::Url)
    end
  end

  describe "#command_version" do
    it "should return a Ppl::Command::Version" do
      expect(@bootstrap.command_version).to be_a(Ppl::Command::Version)
    end
  end

  describe "#format_address_book_ages" do

    it "should return a Ppl::Format::AddressBook::Ages" do
      expect(@bootstrap.format_address_book_ages).to be_a(Ppl::Format::AddressBook::Ages)
    end

    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("age").and_return(@colors)
      @bootstrap.format_address_book_ages
    end

  end

  describe "#format_address_book_birthdays" do
    it "should return a Ppl::Format::AddressBook::Birthdays" do
      expect(@bootstrap.format_address_book_birthdays).to be_a(Ppl::Format::AddressBook::Birthdays)
    end

    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("bday").and_return(@colors)
      @bootstrap.format_address_book_birthdays
    end
  end

  describe "#format_address_book_email_addresses" do
    it "should return a Ppl::Format::AddressBook::EmailAddresses" do
      expect(@bootstrap.format_address_book_email_addresses).to be_a(Ppl::Format::AddressBook::EmailAddresses)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("email").and_return(@colors)
      @bootstrap.format_address_book_email_addresses
    end
  end

  describe "#format_address_book_mutt_query" do
    it "should return a Ppl::Format::AddressBook::MuttQuery" do
      expect(@bootstrap.format_address_book_mutt_query).to be_a(Ppl::Format::AddressBook::MuttQuery)
    end
  end

  describe "#format_address_book_organizations" do
    it "should return a Ppl::Format::AddressBook::Organizations" do
      expect(@bootstrap.format_address_book_organizations).to be_a(Ppl::Format::AddressBook::Organizations)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("org").and_return(@colors)
      @bootstrap.format_address_book_organizations
    end
  end

  describe "#format_address_book_names" do
    it "should return a Ppl::Format::AddressBook::Names" do
      expect(@bootstrap.format_address_book_names).to be_a(Ppl::Format::AddressBook::Names)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("name").and_return(@colors)
      @bootstrap.format_address_book_names
    end
  end

  describe "#format_address_book_nicknames" do
    it "should return a Ppl::Format::AddressBook::Nicknames" do
      expect(@bootstrap.format_address_book_nicknames).to be_a(Ppl::Format::AddressBook::Nicknames)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("nick").and_return(@colors)
      @bootstrap.format_address_book_nicknames
    end
  end

  describe "#format_address_book_one_line" do
    it "should return a Ppl::Format::AddressBook::OneLine" do
      expect(@bootstrap.format_address_book_one_line).to be_a(Ppl::Format::AddressBook::OneLine)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("ls").and_return(@colors)
      @bootstrap.format_address_book_one_line
    end
  end

  describe "#format_address_book_phone_numbers" do
    it "should return a Ppl::Format::Address_book::PhoneNumbers" do
      expect(@bootstrap.format_address_book_phone_numbers).to be_a(Ppl::Format::AddressBook::PhoneNumbers)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("phone").and_return(@colors)
      @bootstrap.format_address_book_phone_numbers
    end
  end

  describe "#format_address_book_postal_addresses" do
    it "should return a Ppl::Format::AddressBook::PostalAddresses" do
      expect(@bootstrap.format_address_book_postal_addresses).to be_a(Ppl::Format::AddressBook::PostalAddresses)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("post").and_return(@colors)
      @bootstrap.format_address_book_postal_addresses
    end
  end

  describe "#format_address_book_urls" do
    it "should return a Ppl::Format::AddressBook::Urls" do
      expect(@bootstrap.format_address_book_urls).to be_a(Ppl::Format::AddressBook::Urls)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("url").and_return(@colors)
      @bootstrap.format_address_book_urls
    end
  end

  describe "#format_contact_age" do
    it "should return a Ppl::Format::Contact::Age" do
      expect(@bootstrap.format_contact_age).to be_a(Ppl::Format::Contact::Age)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("age").and_return(@colors)
      @bootstrap.format_contact_age
    end
  end

  describe "#format_contact_birthday" do
    it "should return a Ppl::Format::Contact::Birthday" do
      expect(@bootstrap.format_contact_birthday).to be_a(Ppl::Format::Contact::Birthday)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("bday").and_return(@colors)
      @bootstrap.format_contact_birthday
    end
  end

  describe "#format_contact_email_addresses" do
    it "should return a Ppl::Format::Contact::EmailAddresses" do
      expect(@bootstrap.format_contact_email_addresses).to be_a(Ppl::Format::Contact::EmailAddresses)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("email").and_return(@colors)
      @bootstrap.format_contact_email_addresses
    end
  end

  describe "#format_name_full_only" do
    it "should return a Ppl::Format::Contact::Name" do
      expect(@bootstrap.format_name_full_only).to be_a(Ppl::Format::Name::FullOnly)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("name").and_return(@colors)
      @bootstrap.format_name_full_only
    end
  end

  describe "#format_contact_nicknames" do
    it "should return a Ppl::Format::Contact::Nicknames" do
      expect(@bootstrap.format_contact_nicknames).to be_a(Ppl::Format::Contact::Nicknames)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("nick").and_return(@colors)
      @bootstrap.format_contact_nicknames
    end
  end

  describe "#format_contact_organizations" do
    it "should return a Ppl::Format::Contact::Organizations" do
      expect(@bootstrap.format_contact_organizations).to be_a(Ppl::Format::Contact::Organization)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("org").and_return(@colors)
      @bootstrap.format_contact_organizations
    end
  end

  describe "#format_contact_phone_numbers" do
    it "should return a Ppl::Format::Contact::PhoneNumber" do
      expect(@bootstrap.format_contact_phone_numbers).to be_a(Ppl::Format::Contact::PhoneNumber)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("phone").and_return(@colors)
      @bootstrap.format_contact_phone_numbers
    end
  end

  describe "#format_contact_postal_addresses" do
    it "should return a Ppl::Format::Contact::PostalAddresses" do
      expect(@bootstrap.format_contact_postal_addresses).to be_a(Ppl::Format::Contact::PostalAddresses)
    end
  end

  describe "#format_contact_urls" do
    it "should return a Ppl::Format::Contact::Urls" do
      expect(@bootstrap.format_contact_urls).to be_a(Ppl::Format::Contact::Urls)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      expect(@config).to receive(:command_colors).with("url").and_return(@colors)
      @bootstrap.format_contact_urls
    end
  end

  describe "#format_postal_address_multi_line" do
    it "should return a Ppl::Format::PostalAddress::MultiLine" do
      expect(@bootstrap.format_postal_address_multi_line).to be_a(Ppl::Format::PostalAddress::MultiLine)
    end
  end

  describe "#command_suite" do

    before(:each) do
      allow(@bootstrap).to receive(:storage_adapter)
    end

    it "should return a Ppl::Application::CommandSuite" do
      expect(@bootstrap.command_suite).to be_a(Ppl::Application::CommandSuite)
    end
    it "should contain the 'add' command" do
      expect(@bootstrap.command_suite.find_command("add")).not_to be nil
    end
    it "should contain the 'age' command" do
      expect(@bootstrap.command_suite.find_command("age")).not_to be nil
    end
    it "should contain the 'bday' command" do
      expect(@bootstrap.command_suite.find_command("bday")).not_to be nil
    end
    it "should contain the 'completion' command" do
      expect(@bootstrap.command_suite.find_command("completion")).not_to be nil
    end
    it "should contain the 'email' command" do
      expect(@bootstrap.command_suite.find_command("email")).not_to be nil
    end
    it "should contain the 'grep' command" do
      expect(@bootstrap.command_suite.find_command("grep")).not_to be nil
    end
    it "should contain the 'init' command" do
      expect(@bootstrap.command_suite.find_command("init")).not_to be nil
    end
    it "should contain the 'ls' command" do
      expect(@bootstrap.command_suite.find_command("ls")).not_to be nil
    end
    it "should contain the 'mutt' command" do
      expect(@bootstrap.command_suite.find_command("mutt")).not_to be nil
    end
    it "should contain the 'mv' command" do
      expect(@bootstrap.command_suite.find_command("mv")).not_to be nil
    end
    it "should contain the 'name' command" do
      expect(@bootstrap.command_suite.find_command("name")).not_to be nil
    end
    it "should contain the 'nick' command" do
      expect(@bootstrap.command_suite.find_command("nick")).not_to be nil
    end
    it "should contain the 'org' command" do
      expect(@bootstrap.command_suite.find_command("org")).not_to be nil
    end
    it "should contain the 'phone' command" do
      expect(@bootstrap.command_suite.find_command("phone")).not_to be nil
    end
    it "should contain the 'post' command" do
      expect(@bootstrap.command_suite.find_command("post")).not_to be nil
    end
    it "should contain the 'pull' command" do
      expect(@bootstrap.command_suite.find_command("pull")).not_to be nil
    end
    it "should contain the 'push' command" do
      expect(@bootstrap.command_suite.find_command("push")).not_to be nil
    end
    it "should contain the 'remote' command" do
      expect(@bootstrap.command_suite.find_command("remote")).not_to be nil
    end
    it "should contain the 'rm' command" do
      expect(@bootstrap.command_suite.find_command("rm")).not_to be nil
    end
    it "should contain the 'scrape' command" do
      expect(@bootstrap.command_suite.find_command("scrape")).not_to be nil
    end
    it "should contain the 'show' command" do
      expect(@bootstrap.command_suite.find_command("show")).not_to be nil
    end
    it "should contain the 'help' command" do
      expect(@bootstrap.command_suite.find_command("help")).not_to be nil
    end
    it "should contain the 'shell' command" do
      expect(@bootstrap.command_suite.find_command("shell")).not_to be nil
    end
    it "should contain the 'url' command" do
      expect(@bootstrap.command_suite.find_command("url")).not_to be nil
    end
    it "should contain the 'version' command" do
      expect(@bootstrap.command_suite.find_command("version")).not_to be nil
    end
  end

  describe "#configuration" do
    it "should return a Ppl::Application::Configuration" do
      expect(@bootstrap.configuration).to be_a(Ppl::Application::Configuration)
    end
  end

  describe "#input" do
    it "should return a Ppl::Application::Input" do
      expect(@bootstrap.input).to be_a(Ppl::Application::Input)
    end
  end

  describe "#output" do
    it "should return a Ppl::Application::Output" do
      expect(@bootstrap.output).to be_a(Ppl::Application::Output)
    end
  end

  describe "#router" do
    before(:each) do
      allow(@bootstrap).to receive(:storage_adapter)
    end
    it "should return a Ppl::Application::Router" do
      expect(@bootstrap.router).to be_a(Ppl::Application::Router)
    end
    it "should set the 'help' command as the default" do
      expect(@bootstrap.router.default).to eq "help"
    end
    it "should inject the user's aliases" do
      expect(@bootstrap.router.aliases).to be_a(Hash)
    end
  end

  describe "#shell" do
    before(:each) do
      allow(@bootstrap).to receive(:storage_adapter)
    end
    it "should return a Ppl::Application::Shell" do
      expect(@bootstrap.shell).to be_a(Ppl::Application::Shell)
    end
  end

  describe "#storage_adapter" do
    before(:each) do
      @config  = double(Ppl::Application::Configuration)
      @factory = double(Ppl::Adapter::Storage::Factory)
      allow(@bootstrap).to receive(:configuration).and_return(@config)
      allow(Ppl::Adapter::Storage::Factory).to receive(:new).and_return(@factory)

      expect(@config).to receive(:address_book_path).and_return("/tmp")
      expect(@factory).to receive(:load_adapter).and_return(Ppl::Adapter::Storage::Disk.new(nil))
    end
    it "should return a Ppl::Adapter::Storage" do
      expect(@bootstrap.storage_adapter).to be_a(Ppl::Adapter::Storage)
    end
  end

  describe "#vcard_adapter" do
    it "should return a Ppl::Adapter::Vcard::Vpim" do
      expect(@bootstrap.vcard_adapter).to be_a(Ppl::Adapter::Vcard::Vpim)
    end
  end

  describe "#name_service" do
    it "should return a Ppl::Service::Name" do
      expect(@bootstrap.name_service).to be_a(Ppl::Service::Name)
    end
  end

  describe "#postal_address_service" do
    it "should return a Ppl::Service::PostalAddress" do
      expect(@bootstrap.postal_address_service).to be_a(Ppl::Service::PostalAddress)
    end
  end

end

