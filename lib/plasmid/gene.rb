require 'plasmid/buildable'

# Design notes:
# After a Gene is expressed, other Genes may want to use values that were produced
# during its expression (such as server-generated IDs). We need a way to access
# the "protein" (perhaps a Protein class and attr_accessor :protein)?

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
