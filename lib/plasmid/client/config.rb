require 'plasmid/buildable'

require 'plasmid/database/config'

module Plasmid::Client
  class Config
    include Plasmid::Buildable

    DEFAULT_CACHE_DIR = '/var/cache/plasmid'

    # TODO: create a Hostname or NetAddress class?
    property :database_server, type: Plasmid::Database::Config
    property :cache_dir, type: String

    def initialize
      self.cache_dir = DEFAULT_CACHE_DIR
    end
  end
end
