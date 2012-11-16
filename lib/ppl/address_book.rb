
require "vpim/vcard"
require "enumerator"
require "socket"

class Ppl::Address_Book

  include Enumerable

  def initialize(path, repository)
    @path       = path
    @repository = repository
  end

  def contact(id)
    filename = File.join @path, id + ".vcard"
    if !File.exists? filename
      return nil
    end

    vcard   = IO.read filename
    vcard   = Vpim::Vcard.decode(vcard).first
    contact = Ppl::Contact.new(id, vcard)
  end

  def contacts
    pattern   = File.join @path, "*.vcard"
    filenames = Dir.glob pattern
    contacts  = []

    filenames.each do |filename|
      id = File.basename(filename).slice(0..-7)
      contacts.push self.contact(id);
    end
    contacts

  end

  def each
    self.contacts.each { |c| yield c }
  end

  def with_birthday
    self.find_all { |contact| contact.birthday.nil? == false }
  end

  def create_contact(id, full_name)

    vcard = Vpim::Vcard::Maker.make2 do |maker|
      maker.add_name do |name|
        name.given = full_name
      end
    end

    contact = Ppl::Contact.new(id, vcard)
    self.save_contact contact
    contact
  end

  def delete_contact(id)
    filename = File.join @path, id + ".vcard"
    if !File.exists? filename
      return false
    end
    File.delete filename
  end

  def save_contact(contact)
    basename = contact.id + ".vcard"
    absolute = File.join @path, contact.id + ".vcard"
    File.open(absolute, "w") do |file|
      file.write contact.to_s
    end
  end

  def rename_contact(contact, new_id)
    src = File.join @path, contact.id + ".vcard"
    dst = File.join @path, new_id     + ".vcard"

    File.rename src, dst
  end

  def commit(message)

    index = @repository.index
    index.reload
    self.each do |contact|
      index.add contact.id + ".vcard"
    end
    index.write

    hash    = index.write_tree
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

    commit = Rugged::Commit.create(@repository, data)
  end

end

