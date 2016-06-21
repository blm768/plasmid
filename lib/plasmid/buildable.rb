require 'plasmid/validatable'

#TODO: figure out copyright on original Bookie code.
module Plasmid
  ##
  #Represents an object with a "builder" DSL
  module Buildable
    def self.included(other_module)
      # Pull in "dependencies"
      other_module.include(Validatable)

      # Pull in class methods
      other_module.extend(ClassMethods)

      # Make sure subclasses also include Buildable and get their own builders
      # We need to save the class's existing inheritance hook and call it when
      # we're done.
      old_inheritance_hook = other_module.method(:inherited)
      other_module.define_singleton_method(:inherited) do |klass|
        klass.include(Buildable)
        old_inheritance_hook.call(klass)
      end

      # Create the builder class
      # TODO: unit test the uniqueness of builders to their classes.
      other_module.const_set(:Builder, Class.new do
          include Builder

          define_method(:initialize) do
            @built = other_module.new
          end
        end)
    end

    module ClassMethods
      ##
      #Returns the builder class
      #
      #If a block is given, it is evaluated within the context of the builder class.
      def builder(&block)
        builder_class = const_get(:Builder)
        builder_class.instance_eval(&block) if block_given?
        builder_class
      end

      ##
      # Creates a builder, evaluates the given block in its context, and
      # returns what it built
      def build(&block)
        builder = const_get(:Builder).new
        builder.instance_eval(&block)
        builder.built
      end

      ##
      # Creates a builder property
      #
      # Options:
      # - type: the property's type
      # - allow_nil: allow nil values (default is <tt>false</tt> if type is specified, <tt>true</tt> otherwise)
      # - create_writer: create a proxy writer method in the builder class (default is <tt>true</tt>)
      def property(name, options = nil)
        options ||= {}
        writer_name = "#{name}=".intern
        var_name = "@#{name}".intern

        attr_accessor(name)

        # Handle nil- and type-checking.
        type = options[:type]
        allow_nil = options[:allow_nil]
        if type then
          allow_nil = false if allow_nil.nil?
          validate_self do
            value_class = self.send(name).class
            next if allow_nil && value_class <= NilClass
            raise TypeError.new("Invalid type #{value_class} for field '#{name}': #{type} expected") unless value_class <= type
          end
        else
          allow_nil = true if allow_nil.nil?
          if not allow_nil then
            validate_self do
              raise TypeError.new("Field '#{name}' must not be nil") if self.send(name).nil?
            end
          end
        end

        #TODO: refactor this logic?
        create_writer = options[:create_writer]
        create_writer = true if create_writer.nil?
        const_get(:Builder).property_writer(name) if create_writer
      end
    end
  end

  ##
  # Mixins for builder classes
  module Builder
    def self.included(other_module)
      other_module.extend(ClassMethods)
    end

    #TODO: support renaming of this.
    attr_reader :built

    module ClassMethods
      # TODO: just forward stuff with method_missing?
      def property_reader(name)
        name = name.intern
        define_method(name) do
          @built.send(name)
        end
      end

      # TODO: take a block for custom logic?
      def property_writer(name)
        writer_name = "#{name}=".intern
        define_method(name) do |value|
          @built.send(writer_name, value)
        end
      end
    end
  end
end
