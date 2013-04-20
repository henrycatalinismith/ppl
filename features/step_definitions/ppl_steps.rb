
def ppl(command)
  project_root = File.dirname(File.dirname(File.dirname(__FILE__)))
  ppl_location = File.join(project_root, "bin", "ppl")
  real_command = "#{ppl_location} #{command}"
  `#{real_command}`.strip
end

When /^I run "ppl ([^"]+)"$/ do |command|
  ppl command
end

Then /^it should fail$/ do
  $?.exitstatus.should_not eq 0
end

Then /^there should be 1 contact$/ do
  contact_list = ppl("ls").strip.split("\n")
  contact_list.length.should eq 1
  @contact_id = contact_list[0].split(":").first
end

Then /^(bob) should have (\d+) email addresse?s?$/ do |name, number|
  @email_addresses = ppl("email #{name}").split("\n")
  @email_addresses.length.should eq number.to_i
end

Then /^(bob) should have (\d+) organizations?$/ do |name, number|
  @organizations = ppl("org #{name}").split("\n")
  @organizations.length.should eq number.to_i
end

Then /^(bob) should have (\d+) phone numbers?$/ do |name, number|
  @phone_numbers = ppl("phone #{name}").split("\n")
  @phone_numbers.length.should eq number.to_i
end

And /^its name should be "([^"]+)"$/ do |name|
  ppl("name #{@contact_id}").should eq name
end

Then(/^the (\d+).. email address should be "([^"]+)"$/) do |nth, address|
  @email_addresses[nth.to_i - 1].should eq address
end

Then(/^the (\d+).. organization should be "([^"]+)"$/) do |nth, organization|
  @organizations[nth.to_i - 1].should eq organization
end

Then(/^the (\d+).. phone number should be "([^"]+)"$/) do |nth, phone_number|
  @phone_numbers[nth.to_i - 1].should eq phone_number
end


