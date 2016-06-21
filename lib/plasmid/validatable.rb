module Plasmid
  module Validatable
    def self.included(other_module)
      other_module.extend(ClassMethods)
    end

    #TODO: accumulate validation errors and display them all at once?
    def validate!
      self.class.validators.each do |validator|
        self.instance_eval(&validator)
      end
    end

    module ClassMethods
      attr_reader :validators
      def validate_self(&block)
        @validators ||= []
        @validators.push(block)
      end
    end
  end
end
