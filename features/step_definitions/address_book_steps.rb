Then /^"([^"]+)" should be a ppl address book$/ do |directory|
  git_directory = File.join(directory, ".git")
  Dir.exist?(git_directory).should eq true
end

Then /^I have a vcf file called "contacts\.vcf" containing the following vcards$/ do |table|
  vcf = table.hashes.reduce("") do |string, person|
    string + <<-eos
BEGIN:VCARD
VERSION:3.0
N:;;;;
FN:#{person["Name"]}
NICKNAME:
END:VCARD
eos
  end

  @import_directory = Dir.mktmpdir
  filename = File.join(@import_directory, "contacts.vcf")

  at_exit do
    FileUtils.rm_rf @import_directory
  end
end

When /^I import "contacts\.vcf"$/ do
  filename = File.join(@import_directory, "contacts.vcf")
  command = "import #{filename}"
  ppl command
end

Then(/^there should be (\d+) contacts as follows$/) do |contact_count, table|
  contact_list = ppl("ls").strip.split("\n")
  contact_list.length.should eq contact_count.to_i

  table.hashes.each_with_index do |person, i|
    contact_list[i].should eq person["Name"]
  end
end
