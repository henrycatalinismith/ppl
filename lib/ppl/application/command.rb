
class Ppl::Application::Command

  attr_accessor :description
  attr_accessor :storage

  def execute(input, output)
    raise NotImplementedError
  end

  def options(parser, options)
  end

  @@property_names  = []
  @@property_values = {}

  def self.add_property(name)
    @@property_names = []
    @@property_values[name] = {}

    define_singleton_method(name) do |value = nil|
      if value.nil?
        @@property_values[name][self]
      else
        @@property_values[name][self] = value
      end
    end
    define_method(name) do
      instance_variable = instance_variable_get("@#{name}")
      class_variable    = @@property_values[name][self.class]
      if !instance_variable.nil?
        instance_variable
      elsif !class_variable.nil?
        class_variable
      end
    end
    define_method("#{name}=") do |value|
      instance_variable_set("@#{name}", value)
    end
  end

  add_property :name
  add_property :description

end

