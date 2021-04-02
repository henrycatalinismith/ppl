
def ppl(command)
  project_root = File.dirname(File.dirname(File.dirname(__FILE__)))
  ppl_location = File.join(project_root, "bin", "ppl")
  real_command = "#{ppl_location} #{command}"
  `#{real_command}`.strip
end

When /^I run "ppl ([^"]+)"$/ do |command|
  ppl command
end

Then /^it should succeed$/ do
  expect($?.exitstatus).to eq 0
end

Then /^it should fail$/ do
  expect($?.exitstatus).not_to eq 0
end

Then /^there should be (\d+) contacts?$/ do |n|
  contact_list = ppl("ls").strip.split("\n")
  contact_list.length.should eq n.to_i
  if contact_list[0]
    @contact_id = contact_list[0].split(":").first
  end
end

Then /^(bob) should have (\d+) email addresse?s?$/ do |name, number|
  @email_addresses = ppl("email #{name}").split("\n")
  expect(@email_addresses.length).to eq number.to_i
end

Then /^(bob) should have (\d+) nicknames?$/ do |name, number|
  @nicknames = ppl("nick #{name}").split("\n")
  @nicknames.length.should eq number.to_i
end

Then /^(bob) should have (\d+) organizations?$/ do |name, number|
  @organizations = ppl("org #{name}").split("\n")
  @organizations.length.should eq number.to_i
end

Then /^(bob) should have (\d+) phone numbers?$/ do |name, number|
  @phone_numbers = ppl("phone #{name}").split("\n")
  @phone_numbers.length.should eq number.to_i
end

Then /^(bob) should have (\d+) postal addresse?s?$/ do |name, number|
  @postal_addresses = ppl("post #{name}").split("\n")
  @postal_addresses.length.should eq number.to_i
end

Then /^(bob) should have (\d+) URLs?$/ do |name, number|
  @urls = ppl("url #{name}").split("\n")
  @urls.length.should eq number.to_i
end

And /^its ID should be "([^"]+)"$/ do |id|
  @contact_id.should eq id
end

And /^its name should be "([^"]+)"$/ do |name|
  ppl("name #{@contact_id}").should eq name
end

Then(/^the (\d+).. email address should be "([^"]+)"$/) do |nth, address|
  @email_addresses[nth.to_i - 1].strip.should eq address
end

Then /^running "ppl ([^"]+)" should output (\d+) lines?$/ do |command, lines|
  @output = ppl(command).split("\n")
  @output.length.should eq lines.to_i
end

And /^the (\d+).. line should be "([^"]+)"$/ do |nth, line|
  @output[nth.to_i - 1].should eq line
end

Then(/^the (\d+).. nickname should be "([^"]+)"$/) do |nth, nickname|
  @nicknames[nth.to_i - 1].should eq nickname
end

Then(/^the (\d+).. organization should be "([^"]+)"$/) do |nth, organization|
  @organizations[nth.to_i - 1].should eq organization
end

Then(/^the (\d+).. phone number should be "([^"]+)"$/) do |nth, phone_number|
  @phone_numbers[nth.to_i - 1].should eq phone_number
end

Then(/^the (\d+).. postal address should be "([^"]+)"$/) do |nth, address|
  @postal_addresses[nth.to_i - 1].should eq address
end

Then(/^the (\d+).. URL should be "([^"]+)"$/) do |nth, url|
  @urls[nth.to_i - 1].should eq url
end

And /^"([^"]+)" should be the favourite email address$/ do |email_address|
  @email_addresses.should include "*  #{email_address}"
  @email_addresses.each do |line|
    if line.include? "*"
      line.should eq "*  #{email_address}"
    end
  end
end

And /^"([^"]+)" should be the preferred phone number$/ do |phone_number|
  @phone_numbers.should include "*  #{phone_number}"
  @phone_numbers.each do |line|
    if line.include? "*"
      line.should eq "*  #{phone_number}"
    end
  end
end

And /^"([^"]+)" should be the preferred postal address$/ do |postal_address|
  @postal_addresses.each do |line|
    if line.include? "*"
      line.should include "*  #{postal_address}"
    end
  end
end

And /^there should be no favourite email address$/ do
  @email_addresses.each do |line|
    line.should_not include "*"
  end
end

And /^there should be no preferred phone number$/ do
  @phone_numbers.each do |line|
    line.should_not include "*"
  end
end

Then /^(bob)'s birthday should be "([^"]+)"$/ do |id, birthday|
  ppl("bday #{id}").should eq birthday
end

And /^(bob)'s name is "([^"]+)"$/ do |id, name|
  ppl("name #{id} \"#{name}\"")
end

And /^(bob)'s email address is "([^"]+)"$/ do |id, email_address|
  ppl("email #{id} \"#{email_address}\"")
end

