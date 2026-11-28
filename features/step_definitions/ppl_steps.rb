require "date"

Before do
  @home = Dir.mktmpdir
end

After do
  FileUtils.rm_rf @home
end

def ppl(command)
  project_root = File.dirname(File.dirname(File.dirname(__FILE__)))
  ppl_location = ENV.fetch("PPL_BIN") { File.join(project_root, "target", "debug", "ppl") }
  real_command = "HOME=#{@home} XDG_CONFIG_HOME=#{@home}/.config #{ppl_location} #{command}"
  `#{real_command}`.strip
end

Then /^the default address book should be "([^"]+)"$/ do |path|
  config = File.read(File.join(@home, ".pplconfig"))
  expect(config).to include "path = #{File.realpath(path)}"
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
  expect(contact_list.length).to eq n.to_i
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
  expect(@nicknames.length).to eq number.to_i
end

Then /^(bob) should have (\d+) organizations?$/ do |name, number|
  @organizations = ppl("org #{name}").split("\n")
  expect(@organizations.length).to eq number.to_i
end

Then /^(bob) should have (\d+) phone numbers?$/ do |name, number|
  @phone_numbers = ppl("phone #{name}").split("\n")
  expect(@phone_numbers.length).to eq number.to_i
end

Then /^(bob) should have (\d+) postal addresse?s?$/ do |name, number|
  @postal_addresses = ppl("post #{name}").split("\n")
  expect(@postal_addresses.length).to eq number.to_i
end

Then /^(bob) should have (\d+) URLs?$/ do |name, number|
  @urls = ppl("url #{name}").split("\n")
  expect(@urls.length).to eq number.to_i
end

And /^its ID should be "([^"]+)"$/ do |id|
  expect(@contact_id).to eq id
end

And /^its name should be "([^"]+)"$/ do |name|
  expect(ppl("name #{@contact_id}")).to eq name
end

Then(/^the (\d+).. email address should be "([^"]+)"$/) do |nth, address|
  expect(@email_addresses[nth.to_i - 1].strip).to eq address
end

Then /^running "ppl ([^"]+)" should output (\d+) lines?$/ do |command, lines|
  @output = ppl(command).split("\n")
  expect(@output.length).to eq lines.to_i
end

And /^the (\d+).. line should be "([^"]+)"$/ do |nth, line|
  expect(@output[nth.to_i - 1]).to eq line
end

Then(/^the (\d+).. nickname should be "([^"]+)"$/) do |nth, nickname|
  expect(@nicknames[nth.to_i - 1]).to eq nickname
end

Then(/^the (\d+).. organization should be "([^"]+)"$/) do |nth, organization|
  expect(@organizations[nth.to_i - 1]).to eq organization
end

Then(/^the (\d+).. phone number should be "([^"]+)"$/) do |nth, phone_number|
  expect(@phone_numbers[nth.to_i - 1]).to eq phone_number
end

Then(/^the (\d+).. postal address should be "([^"]+)"$/) do |nth, address|
  expect(@postal_addresses[nth.to_i - 1]).to eq address
end

Then(/^the (\d+).. URL should be "([^"]+)"$/) do |nth, url|
  expect(@urls[nth.to_i - 1]).to eq url
end

And /^"([^"]+)" should be the favourite email address$/ do |email_address|
  expect(@email_addresses).to include "*  #{email_address}"
  @email_addresses.each do |line|
    if line.include? "*"
      expect(line).to eq "*  #{email_address}"
    end
  end
end

And /^"([^"]+)" should be the preferred phone number$/ do |phone_number|
  expect(@phone_numbers).to include "*  #{phone_number}"
  @phone_numbers.each do |line|
    if line.include? "*"
      expect(line).to eq "*  #{phone_number}"
    end
  end
end

And /^"([^"]+)" should be the preferred postal address$/ do |postal_address|
  @postal_addresses.each do |line|
    if line.include? "*"
      expect(line).to include "*  #{postal_address}"
    end
  end
end

And /^there should be no favourite email address$/ do
  @email_addresses.each do |line|
    expect(line).not_to include "*"
  end
end

And /^there should be no preferred phone number$/ do
  @phone_numbers.each do |line|
    expect(line).not_to include "*"
  end
end

Then /^(bob)'s birthday should be "([^"]+)"$/ do |id, birthday|
  expect(ppl("bday #{id}")).to eq birthday
end

And /^(bob)'s birthday was (\d+) years ago today$/ do |id, years|
  ppl("bday #{id} #{(Date.today << (years.to_i * 12)).iso8601}")
end

When /^I run "ppl ([^"]+)" with this input:$/ do |command, input|
  input_file = File.join(@home, "stdin")
  File.write(input_file, input + "\n")
  @output = ppl("#{command} < #{input_file}").split("\n")
end

Then /^it should output (\d+) lines?$/ do |lines|
  expect(@output.length).to eq lines.to_i
end

Then /^(bob)'s vcard should include "([^"]+)"$/ do |id, line|
  expect(File.read("#{id}.vcf").split("\n")).to include line
end

And /^(bob)'s name is "([^"]+)"$/ do |id, name|
  ppl("name #{id} \"#{name}\"")
end

And /^(bob)'s email address is "([^"]+)"$/ do |id, email_address|
  ppl("email #{id} \"#{email_address}\"")
end

And /^the (\d+).. line should match "([^"]+)"$/ do |nth, pattern|
  expect(@output[nth.to_i - 1]).to match Regexp.new(pattern)
end

Then /^running "ppl ([^"]+)" should output a line matching "([^"]+)"$/ do |command, pattern|
  expect(ppl(command).split("\n")).to include a_string_matching(Regexp.new(pattern))
end
