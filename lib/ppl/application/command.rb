
class Ppl::Application::Command

  @@property_values = {}

  attr_accessor :storage

  def execute(input, output)
    raise NotImplementedError
  end

  def options(parser, options)
  end

  def self.add_property(name)
    @@property_values[name] = {}
    self.add_static_property_setter(name)
    self.add_instance_property_getter(name)
    self.add_instance_property_setter(name)
  end


  private

  def self.add_static_property_setter(property_name)
    define_singleton_method(property_name) do |value = nil|
      if value.nil?
        @@property_values[property_name][self]
      else
        @@property_values[property_name][self] = value
      end
    end
  end

  def self.add_instance_property_getter(property_name)
    define_method(property_name) do
      instance_variable = instance_variable_get("@#{property_name}")
      class_variable    = @@property_values[property_name][self.class]
      if !instance_variable.nil?
        instance_variable
      elsif !class_variable.nil?
        class_variable
      end
    end
  end

  def self.add_instance_property_setter(property_name)
    define_method("#{property_name}=") do |value|
      instance_variable_set("@#{property_name}", value)
    end
  end

  add_property :name
  add_property :description


end

