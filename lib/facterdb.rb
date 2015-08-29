require 'facter'
require 'jgrep'

module FacterDB

  @@json = "[#{Dir.glob("#{File.expand_path(File.join(File.dirname(__FILE__), '../facts'))}/*/*.facts").map { |f| File.read(f) }.join(',')}]\n"

  def self.get_os_facts(facter_version='*', filter=[])
    if facter_version == '*'
      new_filter = filter
    else
      new_filter = filter.map { |os| os.merge({:facterversion => "/^#{facter_version}\./"}) }
    end
    warn "[DEPRECATION] `get_os_facts` is deprecated. Please use `get_facts(#{new_filter})` instead."
    get_facts(new_filter)
  end

  def self.get_facts(filter=[])
    if filter.is_a?(Array)
      filter_str = filter.map { |f| f.map { |k,v | "#{k}=#{v}" }.join(' and ') }.join(' or ')
    elsif filter.is_a(Hash)
      filter_str = filter.map { |k,v | "#{k}=#{v}" }.join(' and ')
    elsif filter.is_a(String)
      filter_str = filter
    else
      raise 'filter must be either an Array a Hash or a String'
    end
    JGrep.jgrep(@@json, filter_str)
  end
end
