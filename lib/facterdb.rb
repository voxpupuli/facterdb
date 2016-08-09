require 'facter'
require 'jgrep'

module FacterDB
  # returns Hash of filenames to fact Hashes
  def self.build_database( fs )
    Hash[
      Dir.glob(fs).map do |f|
        t = File.read(f)
        [f,JSON.parse(t)]
      end
    ]
  end


  def self.database
    fs = File.expand_path('../facts/*/*.facts',File.dirname(__FILE__))
    @database ||= build_database( fs ).values.to_json
  end


  def self.get_os_facts(facter_version='*', filter=[])
    if facter_version == '*'
      if filter.is_a?(Array)
        filter_str = filter.map { |f| f.map { |k,v | "#{k}=#{v}" }.join(' and ') }.join(' or ')
      elsif filter.is_a?(Hash)
        filter_str = filter.map { |k,v | "#{k}=#{v}" }.join(' and ')
      elsif filter.is_a?(String)
        filter_str = filter
      else
        raise 'filter must be either an Array a Hash or a String'
      end
    else
      if filter.is_a?(Array)
        filter_str = "facterversion=/^#{facter_version}/ and (#{filter.map { |f| f.map { |k,v | "#{k}=#{v}" }.join(' and ') }.join(' or ')})"
      elsif filter.is_a?(Hash)
        filter_str = "facterversion=/^#{facter_version}/ and (#{filter.map { |k,v | "#{k}=#{v}" }.join(' and ')})"
      elsif filter.is_a?(String)
        filter_str = "facterversion=/^#{facter_version}/ and (#{filter})"
      else
        raise 'filter must be either an Array a Hash or a String'
      end
    end

    warn "[DEPRECATION] `get_os_facts` is deprecated. Please use `get_facts(#{filter_str})` instead."

    get_facts(filter_str)
  end

  def self.get_facts(filter=nil)
    if filter.is_a?(Array)
      filter_str = '(' + filter.map { |f| f.map { |k,v | "#{k}=#{v}" }.join(' and ') }.join(') or (') + ')'
    elsif filter.is_a?(Hash)
      filter_str = filter.map { |k,v | "#{k}=#{v}" }.join(' and ')
    elsif filter.is_a?(String)
      filter_str = filter
    elsif filter == nil
      filter_str = ''
    else
      raise 'filter must be either an Array a Hash or a String'
    end
    JGrep.jgrep(database, filter_str).map { |hash| Hash[hash.map{ |k, v| [k.to_sym, v] }] }
  end
end
