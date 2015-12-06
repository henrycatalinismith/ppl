Given(/^bob has a contact picture$/) do
  filename = File.join(@directory, "bob.vcf")

  vcard = [
    "BEGIN:VCARD",
    "VERSION:3.0",
    "N:;Bob;;;",
    "FN:Bob",
    "NICKNAME:",
    "PHOTO;ENCODING=b;TYPE=JPEG:/9j/4AAQSkZJRgABAQAASABIAAD/4QBARXhpZgAATU0AKgAA",
    "END:VCARD",
  ].join("\n")

  File.open(filename, "w") do |file|
    file.write(vcard)
  end
end

Then(/^bob still has his contact picture$/) do
  filename = File.join(@directory, "bob.vcf")
  vcard = File.read filename

  expect(vcard).to include("PHOTO;ENCODING=b;TYPE=JPEG:/9j/4AAQSkZJRgABAQAASABIAAD/4QBARXhpZgAATU0AKgAA")
end

