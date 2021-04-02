class Ppl::Command::Ls < Ppl::Application::Command

  name        "ls"
  description "List all contacts"

  attr_writer :default_format
  attr_writer :custom_format

  def options(parser, options)
    parser.banner = "usage: ppl ls"
    parser.on("--format <format>", "specify a custom output format") do |format|
      options[:format] = format
    end
    parser.on("--pretty <format>", "specify a custom output format") do |pretty|
      options[:pretty] = pretty
    end
  end

  def execute(input, output)
    address_book = @storage.load_address_book
    formatted    = format_address_book(address_book, input.options)
    output.line(formatted)
    true
  end

  private

  def format_address_book(address_book, options)
    if custom_formatting? options
      use_custom_format(address_book, options)
    else
      @default_format.process(address_book)
    end
  end

  def custom_formatting?(options)
    options[:pretty] || options[:format]
  end

  def use_custom_format(address_book, options)
    if !options[:pretty].nil?
      @custom_format.use_preset options[:pretty]
    elsif !options[:format].nil?
      @custom_format.format = options[:format]
    end
    address_book.contacts.map { |c| @custom_format.process(c) }.join("\n")
  end

end

