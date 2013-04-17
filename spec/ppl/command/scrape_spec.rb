
describe Ppl::Command::Scrape do

  before(:each) do
    @command = Ppl::Command::Scrape.new
    @input   = Ppl::Application::Input.new
    @output  = double(Ppl::Application::Output)
    @storage = double(Ppl::Adapter::Storage)
    @address_book = double(Ppl::Entity::AddressBook)
    @command.storage  = @storage
  end

  describe "#name" do
    it "should be 'scrape'" do
      @command.name.should eq "scrape"
    end
  end

  describe "#execute" do

    it "should scrape the sender's address if requested" do
      @input.options[:sender] = true
      @input.stdin = [
        "Received: by 10.58.205.235 with HTTP; Fri, 30 Nov 2012 09:09:33 -0800 (PST)",
        "Date: Fri, 30 Nov 2012 17:09:33 +0000",
        "From: Test User <test@example.org>",
        "Delivered-To: henry@henrysmith.org",
        "Message-ID: <qwertyuioasdfghjk@mail.gmail.com>",
        "Subject: Test Email",
        "To: henry@henrysmith.org",
        "",
        "Hey,",
        "This is a test email.",
        "Bye!",
      ].join("\n")

      @storage.should_receive(:save_contact) do |contact|
        contact.name.should eq "Test User"
        contact.email_addresses.first.should eq "test@example.org"
      end

      @command.execute(@input, @output)
    end

  end

end

