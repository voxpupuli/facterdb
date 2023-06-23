require 'facterdb'
require 'json'

module FacterDB
  class Bin
    def initialize(args)
      @args = args
    end

    def run
      puts JSON.pretty_generate(FacterDB.get_os_facts('*', @args[0]))
    end
  end
end
