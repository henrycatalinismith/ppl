
describe Ppl::Application::Bootstrap do

  before(:each) do
    @bootstrap = Ppl::Application::Bootstrap.new
  end

  describe "#command_add" do
    it "should return a Ppl::Command::Add" do
      @bootstrap.command_add.should be_a(Ppl::Command::Add)
    end
  end

  describe "#command_age" do
    it "should return a Ppl::Command::Age" do
      @bootstrap.command_age.should be_a(Ppl::Command::Age)
    end
  end

  describe "#command_bday" do
    it "should return a Ppl::Command::Bday" do
      @bootstrap.command_bday.should be_a(Ppl::Command::Bday)
    end
  end

  describe "#command_completion" do
    it "should return a Ppl::Command::Completion" do
      @bootstrap.command_completion.should be_a(Ppl::Command::Completion)
    end
    it "should inject a completions directory" do
      Ppl::Command::Completion.stub(:new) do
        completion = double(Ppl::Command::Completion)
        completion.should_receive(:completions_directory=)
        completion
      end
      @bootstrap.command_completion
    end
  end

  describe "#command_email" do
    it "should return a Ppl::Command::Email" do
      @bootstrap.command_email.should be_a(Ppl::Command::Email)
    end
  end

  describe "#command_grep" do
    it "should return a command" do
      @bootstrap.command_grep.should be_a(Ppl::Application::Command)
    end
  end

  describe "#command_help" do
    it "should return a Ppl::Command::Help" do
      @bootstrap.command_help.should be_a(Ppl::Command::Help)
    end
  end

  describe "#command_init" do
    it "should return a Ppl::Command::Init" do
      @bootstrap.command_init.should be_a(Ppl::Command::Init)
    end
  end

  describe "#command_ls" do
    it "should return a Ppl::Command::Ls" do
      @bootstrap.command_ls.should be_a(Ppl::Command::Ls)
    end
  end

  describe "#command_mutt" do
    it "should return a Ppl::Command::Mutt" do
      @bootstrap.command_mutt.should be_a(Ppl::Command::Mutt)
    end
  end

  describe "#command_mv" do
    it "should return a Ppl::Command::Mv" do
      @bootstrap.command_mv.should be_a(Ppl::Command::Mv)
    end
  end

  describe "#command_name" do
    it "should return a Ppl::Command::Name" do
      @bootstrap.command_name.should be_a(Ppl::Command::Name)
    end
  end

  describe "#command_nick" do
    it "should return a Ppl::Command::Nick" do
      @bootstrap.command_nick.should be_a(Ppl::Command::Nick)
    end
  end

  describe "#command_org" do
    it "should return a Ppl::Command::Org" do
      @bootstrap.command_org.should be_a(Ppl::Command::Org)
    end
  end

  describe "#command_phone" do
    it "should return a Ppl::Command::Phone" do
      @bootstrap.command_phone.should be_a(Ppl::Command::Phone)
    end
  end

  describe "#command_post" do
    it "should return a Ppl::Command::Post" do
      @bootstrap.command_post.should be_a(Ppl::Command::Post)
    end
  end

  describe "#command_pull" do
    it "should return a command" do
      @bootstrap.command_pull.should be_a(Ppl::Application::Command)
    end
  end

  describe "#command_push" do
    it "should return a command" do
      @bootstrap.command_push.should be_a(Ppl::Application::Command)
    end
  end

  describe "#command_remote" do
    it "should return a command" do
      @bootstrap.command_remote.should be_a(Ppl::Application::Command)
    end
  end

  describe "#command_rm" do
    it "should return a Ppl::Command::Rm" do
      @bootstrap.command_rm.should be_a(Ppl::Command::Rm)
    end
  end

  describe "#command_scrape" do
    it "should return a Ppl::Command::Scrape" do
      @bootstrap.command_scrape.should be_a(Ppl::Command::Scrape)
    end
  end

  describe "#command_shell" do
    it "should return a Ppl::Command::Shell" do
      @bootstrap.command_shell.should be_a(Ppl::Command::Shell)
    end
  end

  describe "#command_show" do
    it "should return a Ppl::Command::Show" do
      @bootstrap.command_show.should be_a(Ppl::Command::Show)
    end
  end

  describe "#command_url" do
    it "should return a Ppl::Command::Url" do
      @bootstrap.command_url.should be_a(Ppl::Command::Url)
    end
  end

  describe "#command_version" do
    it "should return a Ppl::Command::Version" do
      @bootstrap.command_version.should be_a(Ppl::Command::Version)
    end
  end

  describe "#format_address_book_ages" do

    it "should return a Ppl::Format::AddressBook::Ages" do
      @bootstrap.format_address_book_ages.should be_a(Ppl::Format::AddressBook::Ages)
    end

    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("age").and_return(@colors)
      @bootstrap.format_address_book_ages
    end

  end

  describe "#format_address_book_birthdays" do
    it "should return a Ppl::Format::AddressBook::Birthdays" do
      @bootstrap.format_address_book_birthdays.should be_a(Ppl::Format::AddressBook::Birthdays)
    end

    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("bday").and_return(@colors)
      @bootstrap.format_address_book_birthdays
    end
  end

  describe "#format_address_book_email_addresses" do
    it "should return a Ppl::Format::AddressBook::EmailAddresses" do
      @bootstrap.format_address_book_email_addresses.should be_a(Ppl::Format::AddressBook::EmailAddresses)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("email").and_return(@colors)
      @bootstrap.format_address_book_email_addresses
    end
  end

  describe "#format_address_book_mutt_query" do
    it "should return a Ppl::Format::AddressBook::MuttQuery" do
      @bootstrap.format_address_book_mutt_query.should be_a(Ppl::Format::AddressBook::MuttQuery)
    end
  end

  describe "#format_address_book_organizations" do
    it "should return a Ppl::Format::AddressBook::Organizations" do
      @bootstrap.format_address_book_organizations.should be_a(Ppl::Format::AddressBook::Organizations)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("org").and_return(@colors)
      @bootstrap.format_address_book_organizations
    end
  end

  describe "#format_address_book_names" do
    it "should return a Ppl::Format::AddressBook::Names" do
      @bootstrap.format_address_book_names.should be_a(Ppl::Format::AddressBook::Names)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("name").and_return(@colors)
      @bootstrap.format_address_book_names
    end
  end

  describe "#format_address_book_nicknames" do
    it "should return a Ppl::Format::AddressBook::Nicknames" do
      @bootstrap.format_address_book_nicknames.should be_a(Ppl::Format::AddressBook::Nicknames)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("nick").and_return(@colors)
      @bootstrap.format_address_book_nicknames
    end
  end

  describe "#format_address_book_one_line" do
    it "should return a Ppl::Format::AddressBook::OneLine" do
      @bootstrap.format_address_book_one_line.should be_a(Ppl::Format::AddressBook::OneLine)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("ls").and_return(@colors)
      @bootstrap.format_address_book_one_line
    end
  end

  describe "#format_address_book_phone_numbers" do
    it "should return a Ppl::Format::Address_book::PhoneNumbers" do
      @bootstrap.format_address_book_phone_numbers.should be_a(Ppl::Format::AddressBook::PhoneNumbers)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("phone").and_return(@colors)
      @bootstrap.format_address_book_phone_numbers
    end
  end

  describe "#format_address_book_postal_addresses" do
    it "should return a Ppl::Format::AddressBook::PostalAddresses" do
      @bootstrap.format_address_book_postal_addresses.should be_a(Ppl::Format::AddressBook::PostalAddresses)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("post").and_return(@colors)
      @bootstrap.format_address_book_postal_addresses
    end
  end

  describe "#format_address_book_urls" do
    it "should return a Ppl::Format::AddressBook::Urls" do
      @bootstrap.format_address_book_urls.should be_a(Ppl::Format::AddressBook::Urls)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("url").and_return(@colors)
      @bootstrap.format_address_book_urls
    end
  end

  describe "#format_contact_age" do
    it "should return a Ppl::Format::Contact::Age" do
      @bootstrap.format_contact_age.should be_a(Ppl::Format::Contact::Age)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("age").and_return(@colors)
      @bootstrap.format_contact_age
    end
  end

  describe "#format_contact_birthday" do
    it "should return a Ppl::Format::Contact::Birthday" do
      @bootstrap.format_contact_birthday.should be_a(Ppl::Format::Contact::Birthday)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("bday").and_return(@colors)
      @bootstrap.format_contact_birthday
    end
  end

  describe "#format_contact_email_addresses" do
    it "should return a Ppl::Format::Contact::EmailAddresses" do
      @bootstrap.format_contact_email_addresses.should be_a(Ppl::Format::Contact::EmailAddresses)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("email").and_return(@colors)
      @bootstrap.format_contact_email_addresses
    end
  end

  describe "#format_name_full_only" do
    it "should return a Ppl::Format::Contact::Name" do
      @bootstrap.format_name_full_only.should be_a(Ppl::Format::Name::FullOnly)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("name").and_return(@colors)
      @bootstrap.format_name_full_only
    end
  end

  describe "#format_contact_nicknames" do
    it "should return a Ppl::Format::Contact::Nicknames" do
      @bootstrap.format_contact_nicknames.should be_a(Ppl::Format::Contact::Nicknames)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("nick").and_return(@colors)
      @bootstrap.format_contact_nicknames
    end
  end

  describe "#format_contact_organizations" do
    it "should return a Ppl::Format::Contact::Organizations" do
      @bootstrap.format_contact_organizations.should be_a(Ppl::Format::Contact::Organization)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("org").and_return(@colors)
      @bootstrap.format_contact_organizations
    end
  end

  describe "#format_contact_phone_numbers" do
    it "should return a Ppl::Format::Contact::PhoneNumber" do
      @bootstrap.format_contact_phone_numbers.should be_a(Ppl::Format::Contact::PhoneNumber)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("phone").and_return(@colors)
      @bootstrap.format_contact_phone_numbers
    end
  end

  describe "#format_contact_postal_addresses" do
    it "should return a Ppl::Format::Contact::PostalAddresses" do
      @bootstrap.format_contact_postal_addresses.should be_a(Ppl::Format::Contact::PostalAddresses)
    end
  end

  describe "#format_contact_urls" do
    it "should return a Ppl::Format::Contact::Urls" do
      @bootstrap.format_contact_urls.should be_a(Ppl::Format::Contact::Urls)
    end
    it "should set up colored output if configured to do so" do
      @colors = {}
      @config = double(Ppl::Application::Configuration)
      @bootstrap.stub(:configuration).and_return(@config)
      @config.should_receive(:command_colors).with("url").and_return(@colors)
      @bootstrap.format_contact_urls
    end
  end

  describe "#format_postal_address_multi_line" do
    it "should return a Ppl::Format::PostalAddress::MultiLine" do
      @bootstrap.format_postal_address_multi_line.should be_a(Ppl::Format::PostalAddress::MultiLine)
    end
  end

  describe "#command_suite" do

    before(:each) do
      @bootstrap.stub(:storage_adapter)
    end

    it "should return a Ppl::Application::CommandSuite" do
      @bootstrap.command_suite.should be_a(Ppl::Application::CommandSuite)
    end
    it "should contain the 'add' command" do
      @bootstrap.command_suite.find_command("add").should_not be nil
    end
    it "should contain the 'age' command" do
      @bootstrap.command_suite.find_command("age").should_not be nil
    end
    it "should contain the 'bday' command" do
      @bootstrap.command_suite.find_command("bday").should_not be nil
    end
    it "should contain the 'completion' command" do
      @bootstrap.command_suite.find_command("completion").should_not be nil
    end
    it "should contain the 'email' command" do
      @bootstrap.command_suite.find_command("email").should_not be nil
    end
    it "should contain the 'grep' command" do
      @bootstrap.command_suite.find_command("grep").should_not be nil
    end
    it "should contain the 'init' command" do
      @bootstrap.command_suite.find_command("init").should_not be nil
    end
    it "should contain the 'ls' command" do
      @bootstrap.command_suite.find_command("ls").should_not be nil
    end
    it "should contain the 'mutt' command" do
      @bootstrap.command_suite.find_command("mutt").should_not be nil
    end
    it "should contain the 'mv' command" do
      @bootstrap.command_suite.find_command("mv").should_not be nil
    end
    it "should contain the 'name' command" do
      @bootstrap.command_suite.find_command("name").should_not be nil
    end
    it "should contain the 'nick' command" do
      @bootstrap.command_suite.find_command("nick").should_not be nil
    end
    it "should contain the 'org' command" do
      @bootstrap.command_suite.find_command("org").should_not be nil
    end
    it "should contain the 'phone' command" do
      @bootstrap.command_suite.find_command("phone").should_not be nil
    end
    it "should contain the 'post' command" do
      @bootstrap.command_suite.find_command("post").should_not be nil
    end
    it "should contain the 'pull' command" do
      @bootstrap.command_suite.find_command("pull").should_not be nil
    end
    it "should contain the 'push' command" do
      @bootstrap.command_suite.find_command("push").should_not be nil
    end
    it "should contain the 'remote' command" do
      @bootstrap.command_suite.find_command("remote").should_not be nil
    end
    it "should contain the 'rm' command" do
      @bootstrap.command_suite.find_command("rm").should_not be nil
    end
    it "should contain the 'scrape' command" do
      @bootstrap.command_suite.find_command("scrape").should_not be nil
    end
    it "should contain the 'show' command" do
      @bootstrap.command_suite.find_command("show").should_not be nil
    end
    it "should contain the 'help' command" do
      @bootstrap.command_suite.find_command("help").should_not be nil
    end
    it "should contain the 'shell' command" do
      @bootstrap.command_suite.find_command("shell").should_not be nil
    end
    it "should contain the 'url' command" do
      @bootstrap.command_suite.find_command("url").should_not be nil
    end
    it "should contain the 'version' command" do
      @bootstrap.command_suite.find_command("version").should_not be nil
    end
  end

  describe "#configuration" do
    it "should return a Ppl::Application::Configuration" do
      @bootstrap.configuration.should be_a(Ppl::Application::Configuration)
    end
  end

  describe "#input" do
    it "should return a Ppl::Application::Input" do
      @bootstrap.input.should be_a(Ppl::Application::Input)
    end
  end

  describe "#output" do
    it "should return a Ppl::Application::Output" do
      @bootstrap.output.should be_a(Ppl::Application::Output)
    end
  end

  describe "#router" do
    before(:each) do
      @bootstrap.stub(:storage_adapter)
    end
    it "should return a Ppl::Application::Router" do
      @bootstrap.router.should be_a(Ppl::Application::Router)
    end
    it "should set the 'help' command as the default" do
      @bootstrap.router.default.should eq "help"
    end
    it "should inject the user's aliases" do
      @bootstrap.router.aliases.should be_a(Hash)
    end
  end

  describe "#shell" do
    before(:each) do
      @bootstrap.stub(:storage_adapter)
    end
    it "should return a Ppl::Application::Shell" do
      @bootstrap.shell.should be_a(Ppl::Application::Shell)
    end
  end

  describe "#storage_adapter" do
    before(:each) do
      @config  = double(Ppl::Application::Configuration)
      @factory = double(Ppl::Adapter::Storage::Factory)
      @bootstrap.stub(:configuration).and_return(@config)
      Ppl::Adapter::Storage::Factory.stub(:new).and_return(@factory)

      @config.should_receive(:address_book_path).and_return("/tmp")
      @factory.should_receive(:load_adapter).and_return(Ppl::Adapter::Storage::Disk.new(nil))
    end
    it "should return a Ppl::Adapter::Storage" do
      @bootstrap.storage_adapter.should be_a(Ppl::Adapter::Storage)
    end
  end

  describe "#vcard_adapter" do
    it "should return a Ppl::Adapter::Vcard::Vpim" do
      @bootstrap.vcard_adapter.should be_a(Ppl::Adapter::Vcard::Vpim)
    end
  end

  describe "#name_service" do
    it "should return a Ppl::Service::Name" do
      @bootstrap.name_service.should be_a(Ppl::Service::Name)
    end
  end

  describe "#postal_address_service" do
    it "should return a Ppl::Service::PostalAddress" do
      @bootstrap.postal_address_service.should be_a(Ppl::Service::PostalAddress)
    end
  end

end

