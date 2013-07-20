
describe Ppl::Adapter::EmailScraper::Mail do

  before(:each) do
    @adapter = Ppl::Adapter::EmailScraper::Mail.new
    @storage = double(Ppl::Adapter::Storage)
    @adapter.storage_adapter = @storage
  end

  describe "#scrape_contacts" do

    it "should return an array" do
      @adapter.scrape_contacts("").should eq []
    end

    it "should scrape the sender's name" do
      email = [
        "Date: Fri, 30 Nov 2012 17:09:33 +0000",
        "From: Test User <test@example.org>",
        "Message-ID: <qwertyuioasdfghjk@mail.example.org>",
        "Subject: Test Email",
        "To: henry@henrysmith.org",
        "",
        "Hey,",
        "This is a test email.",
        "Bye!",
      ].join("\n")
      contacts = @adapter.scrape_contacts(email)
      contacts.first.name.should eq "Test User"
    end

    it "should scrape the sender's email address" do
      email = [
        "Date: Fri, 30 Nov 2012 17:09:33 +0000",
        "From: Test User <test@example.org>",
        "Message-ID: <qwertyuioasdfghjk@mail.example.org>",
        "Subject: Test Email",
        "To: henry@henrysmith.org",
        "",
        "Hey,",
        "This is a test email.",
        "Bye!",
      ].join("\n")
      contacts = @adapter.scrape_contacts(email)
      contacts.first.email_addresses.first.should eq "test@example.org"
    end

    it "should generate an ID for the sender based on their name" do
      email = [
        "Date: Fri, 30 Nov 2012 17:09:33 +0000",
        "From: Test User <test@example.org>",
        "Message-ID: <qwertyuioasdfghjk@mail.example.org>",
        "Subject: Test Email",
        "To: henry@henrysmith.org",
        "",
        "Hey,",
        "This is a test email.",
        "Bye!",
      ].join("\n")
      contacts = @adapter.scrape_contacts(email)
      contacts.first.id.should eq "test_user"
    end

    it "should generate a sender ID based on email address if there's no name" do
      email = [
        "Date: Fri, 30 Nov 2012 17:09:33 +0000",
        "From: test@example.org",
        "Message-ID: <qwertyuioasdfghjk@mail.example.org>",
        "Subject: Test Email",
        "To: henry@henrysmith.org",
        "",
        "Hey,",
        "This is a test email.",
        "Bye!",
      ].join("\n")
      contacts = @adapter.scrape_contacts(email)
      contacts.first.id.should eq "test@example.org"
    end

  end

end

