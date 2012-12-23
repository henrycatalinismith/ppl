
class Ppl::Application::Command

  attr_accessor :description
  attr_accessor :storage

  def execute(input, output)
    raise NotImplementedError
  end

  def options(parser, options)
  end

  @@names = {}
  @@descriptions = {}

  def self.name(name = nil)
    @@names[self] = name || @@names[self]
  end

  def self.description(description = nil)
    @@descriptions[self] = description || @@descriptions[self]
  end

  def name=(name)
    @name = name
  end

  def name
    if @@names[self.class].nil?
      @name
    else
      @@names[self.class]
    end
  end

  def description=(description)
    @description = description
  end

  def description
    if @@descriptions[self.class].nil?
      @description
    else
      @@descriptions[self.class]
    end
  end

end

