
require "rugged"
require "socket"

class Ppl::Adapter::Storage::Git < Ppl::Adapter::Storage

  attr_accessor :disk
  attr_accessor :repository
  attr_accessor :vcard_adapter

  def initialize(disk)
    @disk = disk
    @repository = Rugged::Repository.new(@disk.directory.path)
  end

  def load_address_book
    address_book = Ppl::Entity::AddressBook.new

    head = @repository.lookup(@repository.head.target)
    head.tree.each do |file|
      extension = file[:name].slice(-4..-1)
      if extension != ".vcf"
        next
      end
      contact_id = file[:name].slice(0..-5)
      contact    = load_contact(contact_id)
      address_book.add_contact(contact)
    end

    return address_book
  end

  def load_contact(id)
    filename = id + ".vcf"
    target   = @repository.head.target
    vcard    = @repository.file_at(target, filename)
    contact  = nil

    if !vcard.nil?
      contact    = @vcard_adapter.decode(vcard)
      contact.id = id
    end

    return contact
  end

  def save_contact(contact)
    @disk.save_contact(contact)

    add("#{contact.id}.vcf")
    commit("save_contact(#{contact.id})")
  end

  def delete_contact(contact)
    @repository.index.remove("#{contact.id}.vcf")
    @repository.index.write
    commit("remove_contact(#{contact.id})")
    @disk.delete_contact(contact)
  end

  private

  def add(file)
    @repository.index.add(file)
    @repository.index.write
  end

  def commit(message)
    hash    = @repository.index.write_tree
    tree    = @repository.lookup hash
    parents = [ @repository.lookup( @repository.head.target ).oid ]

    name = ENV['USER']
    host = Socket.gethostname

    author = {
      :email => name + "@" + host,
      :time  => Time.now,
      :name  => name,
    }

    data = {
      :author     => author,
      :message    => message,
      :committer  => author,
      :tree       => tree,
      :parents    => parents,
      :update_ref => "HEAD",
    }

    Rugged::Commit.create(@repository, data)
  end

end

