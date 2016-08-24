# Design notes for refactor:
# Goals
# * Validations are easy to write
# * Produce good error messages
#   * Just strings are OK; no need for fancy subclasses (for now)
#   * Validations must know what they are validating
#
# Tradeoffs
# * Just grab return values of validation blocks?
#   * Means that we need lots of small validations
#   * Wouldn't work with return statements (proc is captured), but break should work.
# * Have error-storing methods?
#  * See below
#  * Encourages (to a degree) longer validation methods with multiple checks
#
# Design ideas:
# * A "ValidationHelper" object
#  * Validation blocks are evaluated in the helper's context
#  * Includes methods to set errors and/or get other helper objects
# * Property-oriented validation
#  * Since we're primarily interested in validating the values of instance
#    variables and attributes, focus the syntax on those?
#
# A quick and dirty solution:
# validate_self do
#   some_property != nil or raise "Problem here!"
# end
#
# Another very simple solution:
# validate_self 'some_property must not be nil' do
#   some_property != nil
# end
#
# And the error message basically just prints out the block listed above.
#
# Attribute-focused validation:
# # Produces the error message "some_property must not be nil"
# validate :some_property do |value|
#   error "must not be nil" if value.nil?
# end
# # For instance variables
# validate :@some_var do |value|
#   ...
# done
# # For generic values
# validate_that 'the parent must know about this object' do
#   parent.children.include?(self)
# end
#
# Borrow some RSpec style?
# validate :some_attribute do |value|
#   it expect(value != nil)
#   it 'satisfies some condition' do stuff end
# end

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
