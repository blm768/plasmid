require 'plasmid/gene'

module Plasmid
  class FileSource

  end

  class LocalFileSource < FileSource
    def initialize(name)
      @filename = name
    end

    def open
      # TODO: open text files in 'r' mode?
      file = File.open(@filename, 'rb')
      return file unless block_given?
      begin
        yield file
      ensure
        file.close
      end
    end
  end

  class StringFileSource < FileSource

  end
end
