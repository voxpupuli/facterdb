require 'facter'
require 'jgrep'

module FacterDB

  def self.get_os_facts(facter_version='*', filter=[])
    facts_dir = File.expand_path(File.join(File.dirname(__FILE__), '../facts'))
    filter_str = filter.map { |f| f.map { |k,v | "#{k}=#{v}" }.join(' and ') }.join(' or ')

    jsons = Dir.glob("#{facts_dir}/#{facter_version}/*.facts").map { |f| File.read(f) }
    json = "[#{jsons.join(',')}]\n"
    JGrep.jgrep(json, filter_str).map { |hash| Hash[hash.map{ |k, v| [k.to_sym, v] }] }
  end
end
