require 'spec_helper'
require 'plasmid/validatable'

class TestValidatable
  include Plasmid::Validatable
end

describe Plasmid::Validatable do
  describe '.included' do
    it 'extends with class methods' do
      class_methods = [:validators, :validate_self]
      class_methods.each do |method|
        expect(TestValidatable.method(method)).to_not be_nil
      end
    end
  end

  describe '#validate' do
    it 'runs validations'
  end

  describe Plasmid::Validatable::ClassMethods do
    describe 'validate_self' do
      it 'adds validators' do
        val_class = TestValidatable.dup
        val_class.validate_self { true }
        expect(val_class.validators).to_not be_empty
      end
    end
  end
end
