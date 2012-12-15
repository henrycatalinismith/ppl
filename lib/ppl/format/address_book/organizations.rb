
class Ppl::Format::AddressBook::Organizations < Ppl::Format::AddressBook

  attr_writer :table

  def initialize
    @table = Ppl::Format::Table.new([:id, :organization])
  end

  def process(address_book)
    address_book.each { |contact| add_row(contact) }
    @table.to_s
  end


  private

  def add_row(contact)
    contact_id   = sprintf("%s:", contact.id)
    organization = nil

    if !contact.organization.nil?
      organization = contact.organization
    end

    @table.add_row({
      :id           => contact_id,
      :organization => organization,
    })
  end


end

