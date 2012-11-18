
require "vpim/vcard"
require "enumerator"
require "socket"

class Ppl::Address_Book

  include Enumerable

  def initialize(repository)
    @repository = repository
    @path       = File.dirname repository.path
  end

  def contact(id)
    vcard = @repository.file_at(@repository.head.target, id + ".vcard")
    if !vcard.nil?
      vcard   = Vpim::Vcard.decode(vcard).first
      contact = Ppl::Contact.new(id, vcard)
    end
  end

  def contacts
    contacts = []
    commit   = @repository.last_commit

    if commit.nil?
      return contacts
    end

    @repository.last_commit.tree.each_blob do |blob|
      if blob[:name].slice(-6 .. -1) == ".vcard"
        id = blob[:name].slice(0 .. -7)
        contacts.push(self.contact(id))
      end
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

