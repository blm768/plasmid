require 'plasmid/file'
require 'plasmid/gene'

module Plasmid::Genes
  class File < Plasmid::Gene
    # TODO: use a variant of Pathname instead?
    property :dest_path, type: String
    property :source, type: Plasmid::FileSource
  end
end
