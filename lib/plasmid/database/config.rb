require 'sequel'

require 'plasmid/buildable'

module Plasmid::Database
  class Config
    include Buildable

    property :adapter, Type: Symbol
    property :host, type: String
    property :port, type: Integer, allow_nil: true
    property :database, type: String
    # TODO: split into a DB auth config type?
    # (Could allow for alternate auth types)
    property :username, type: String
    property :password, type: String

    def initialize
      # TODO: decide whether to include this.
      #self.adapter = :postgres
    end

    ##
    # Connects to the given database and returns the connection object
    #
    # TODO: move this so config doesn't depend on Sequel?
    def connect
      Sequel.connect(
        adapter: self.adapter,
        host: self.host,
        port: self.port,
        database: self.database,
        username: self.username,
        password: self.password,
      )
    end
  end
end
