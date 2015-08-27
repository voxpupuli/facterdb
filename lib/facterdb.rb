require 'facter'
require 'jgrep'

module FacterDB

  def get_os_facts(facter_version='*', filter=[])
    filter_str = filter.map { |f| f.map { |k,v | "#{k}=#{v}" }.join(' and ') }.join(' or ')

    jsons = Dir.glob("facts/#{facter_version}/*.facts").map { |f| File.read(f) }
    json = "[#{jsons.join(',')}]\n"
    JGrep.jgrep(json, filter_str)
  end
end
