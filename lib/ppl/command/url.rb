
class Ppl::Command::Url < Ppl::Application::Command

  name        "url"
  description "List, show or change URLs"

  attr_writer :show_format
  attr_writer :list_format

  def initialize
    @show_format = Ppl::Format::Contact::Urls.new
    @list_format = Ppl::Format::AddressBook::Urls.new
  end

  def options(parser, options)
    parser.banner = "usage: ppl url <contact> [<url>]"
    parser.on("-d", "--delete", "delete url") do
      options[:delete] = true
    end
  end

  def execute(input, output)
    action = determine_action(input)
    send(action, input, output)
  end


  private

  def determine_action(input)
    if input.arguments[0].nil?
      :list_urls
    elsif input.arguments[1].nil?
      :show_urls
    elsif input.options[:delete]
      :delete_url
    else
      :set_url
    end
  end

  def list_urls(input, output)
    address_book = @storage.load_address_book
    url_list     = @list_format.process(address_book)
    output.line(url_list)
  end

  def show_urls(input, output)
    contact = @storage.require_contact(input.arguments[0])
    urls    = @show_format.process(contact)
    if urls != ""
      output.line(urls)
      true
    else
      false
    end
  end

  def delete_url(input, output)
    contact = @storage.require_contact(input.arguments[0])
    old_url = input.arguments[1].dup
    contact.urls.delete(old_url) do
      message = sprintf("%s has no such url %s", contact.id, old_url)
      raise Ppl::Error::IncorrectUsage, message
    end
    @storage.save_contact(contact)
  end

  def set_url(input, output)
    contact = @storage.require_contact(input.arguments[0])
    new_url = input.arguments[1].dup
    if contact.urls.include?(new_url)
      message = sprintf("%s already has url %s", contact.id, new_url)
      raise Ppl::Error::IncorrectUsage, message
    else
      contact.urls.push(new_url)
    end
    @storage.save_contact(contact)
  end

end

