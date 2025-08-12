require 'jgrep'

module FacterDB
  module Errors
    class InvalidFilter < RuntimeError; end
  end

  # @return [String] returns a giant incomprehensible string of concatenated json data
  def self.database
    @database ||= "[#{facterdb_fact_files.map { |f| read_json_file(f) }.join(',')}]\n"
  end

  # @note Call this method at the end of test suite, for example via after(:suite), to reclaim back the memory required to hold json data and filter cache
  def self.cleanup
    @database = nil
    Thread.current[:facterdb_last_filter_seen] = nil
    Thread.current[:facterdb_last_facts_seen] = nil
  end

  # @return [Boolean] returns true if we should use the default facterdb database, false otherwise
  # @note If the user passes anything to the FACTERDB_SKIP_DEFAULTDB environment variable we assume
  # they want to skip the default db
  def self.use_defaultdb?
    ENV['FACTERDB_SKIP_DEFAULTDB'].nil?
  end

  # @return [Boolean] returns true if we should inject the source file name and file path into the json factsets.
  # The default is false.
  def self.inject_source?
    !ENV['FACTERDB_INJECT_SOURCE'].nil?
  end

  def self.read_json_file(f)
    content = File.read(f)
    return content unless inject_source?

    # Find the opening brace
    first_brace = content.index('{')
    return content if first_brace.nil?

    # Inject source file information
    json_injection =  "\"_facterdb_filename\": #{File.basename(f).to_json}, "
    json_injection += "\"_facterdb_path\": #{File.expand_path(f).to_json}, "
    content.insert(first_brace + 1, json_injection)
  end
  private_class_method :read_json_file

  # @return [Array[String]] list of all files found in the default facterdb facts path
  def self.default_fact_files
    return [] unless use_defaultdb?

    proj_root = File.join(File.dirname(__FILE__, 2))
    facts_dir = File.expand_path(File.join(proj_root, 'facts'))
    Dir.glob(File.join(facts_dir, '**', '*.facts'))
  end

  # @return [Array[String]] list of all files found in the user supplied facterdb facts path
  # @param fact_paths [String] a comma separated list of paths to search for fact files
  def self.external_fact_files(fact_paths = ENV.fetch('FACTERDB_SEARCH_PATHS', nil))
    fact_paths ||= ''
    return [] if fact_paths.empty?

    paths = fact_paths.split(File::PATH_SEPARATOR).map do |fact_path|
      unless File.directory?(fact_path)
        warn("[FACTERDB] Ignoring external facts path #{fact_path} as it is not a directory")
        next nil
      end
      fact_path = fact_path.gsub(File::ALT_SEPARATOR, File::SEPARATOR) if File::ALT_SEPARATOR
      File.join(fact_path.strip, '**', '*.facts')
    end.compact
    Dir.glob(paths)
  end

  # @return [Array[String]] list of all files found in the default facterdb facts path and user supplied path
  # @note external fact files supplied by the user will take precedence over default fact files found in this gem
  def self.facterdb_fact_files
    (external_fact_files + default_fact_files).uniq
  end

  # @return [String] the string filter
  # @param filter [Object] The filter to convert to jgrep string
  def self.generate_filter_str(filter = nil)
    case filter
    when ::Array
      '(' + filter.map { |f| f.map { |k, v| "#{k}=#{v}" }.join(' and ') }.join(') or (') + ')'
    when ::Hash
      filter.map { |k, v| "#{k}=#{v}" }.join(' and ')
    when ::String
      filter
    when ::NilClass
      ''
    else
      raise Errors::InvalidFilter, "filter must be either an Array a Hash, String, or nil, received #{filter.class}"
    end
  end

  # @return [Boolean] true if the filter is valid against the jgrep filter validator
  # @param filters [Object] The filter to convert to jgrep string
  def self.valid_filters?(filters)
    filter_str = generate_filter_str(filters)
    JGrep.validate_filters(filter_str).nil?
  rescue RuntimeError
    false
  end

  # @return [Array[Hash[Symbol, Any]]] array of hashes of facts
  # @param filter [Object] The filter to convert to jgrep string
  # @param symbolize_keys [Boolean]
  #   Whether to symbolize the keys. Note this is only on the top level and not
  #   on nested values.
  def self.get_facts(filter = nil, cache = true, symbolize_keys: true)
    if cache && filter && filter == Thread.current[:facterdb_last_filter_seen]
      return Thread.current[:facterdb_last_facts_seen]
    end

    filter_str = generate_filter_str(filter)
    result = JGrep.jgrep(database, filter_str)
    result = result.map { |hash| hash.transform_keys(&:to_sym) } if symbolize_keys
    if cache
      Thread.current[:facterdb_last_filter_seen] = filter
      Thread.current[:facterdb_last_facts_seen] = result
    end
    result
  end
end
