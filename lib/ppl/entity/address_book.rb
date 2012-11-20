
require "enumerator"

class Ppl::Entity::AddressBook

  include Enumerable

  def initialize
    @contacts = []
  end

  def add_contact(contact)
    @contacts.push contact
  end

  def each
    @contacts.each { |contact| yield contact }
  end

end

