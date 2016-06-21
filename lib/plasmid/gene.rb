require 'plasmid/buildable'

module Plasmid
  # TODO: how to handle "leaf" genes (no children)?
  class Gene
    include Buildable

    attr_accessor :genes
    alias_method :[], :genes

    def initialize
      genes = {}
    end

    builder do
      property_reader :genes
    end
  end

  module Genes
  end
end
