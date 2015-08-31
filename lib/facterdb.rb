require 'facter'
require 'jgrep'

module FacterDB

  def self.get_os_facts(facter_version='*', filter=[])
    if filter.is_a?(Array)
      filter_str = filter.map { |f| f.map { |k,v | "#{k}=#{v}" }.join(' and ') }.join(' or ')
    elsif filter.is_a?(Hash)
      filter_str = filter.map { |k,v | "#{k}=#{v}" }.join(' and ')
    elsif filter.is_a?(String)
      filter_str = filter
    else
      raise 'filter must be either an Array a Hash or a String'
    end

    facts_dir = File.expand_path(File.join(File.dirname(__FILE__), '../facts'))

    jsons = Dir.glob("#{facts_dir}/#{facter_version}/*.facts").map { |f| File.read(f) }
    json = "[#{jsons.join(',')}]\n"
    JGrep.jgrep(json, filter_str).map { |hash| Hash[hash.map{ |k, v| [k.to_sym, v] }] }
  end
end
