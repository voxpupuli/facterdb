require 'spec_helper'
require 'digest'

RSpec::Matchers.define :have_a_unique_hash do
  match do |actual|
    actual.count == 1
  end

  failure_message do |actual|
    "expected that fact files #{actual.join(', ')} would be unique"
  end
end

RSpec::Matchers.define :be_valid_json do
  match do |actual|
    content = File.open(actual, 'rb') { |file| file.read }
    valid = false
    begin
      obj = JSON.parse(content)
      valid = true
    rescue JSON::ParserError => e
      raise "Invalid JSON file #{actual}.\n#{e}"
    end
  end

  failure_message do |actual|
    "expected that fact file #{actual} was a valid JSON file."
  end
end

RSpec::Matchers.define :have_facter_version do |expected_facter_version, filepath|
  match do |actual|
    # Simple but naive regex check
    actual =~ /^#{expected_facter_version}($|\.)/
  end

  failure_message do |actual|
    "expected that fact file #{filepath} with facter version #{actual} had a facter version that matched #{expected_facter_version}"
  end
end

describe 'Default Facts' do
  before(:each) do
    ENV['FACTERDB_SKIP_DEFAULTDB'] = nil
    FacterDB.instance_variable_set(:@database, nil)
  end

  describe 'fact files' do
    it 'should not contain duplicate fact sets' do
      # Gather all of the default files and hash the content
      file_hashes = {}
      FacterDB.default_fact_files.each do |filepath|
        file_hash = Digest::SHA256.hexdigest( File.open(filepath, 'rb') { |file| file.read } )
        file_hashes[file_hash] ||= []
        file_hashes[file_hash] << filepath
      end

      file_hashes.keys.each do |file_hash|
        expect(file_hashes[file_hash]).to have_a_unique_hash
      end
    end

    it 'should contain fact sets which match are valid JSON' do
      FacterDB.default_fact_files.each do |filepath|
        expect(filepath).to be_valid_json
      end
    end

    it 'should contain fact sets which match the facter version' do
      FacterDB.default_fact_files.each do |filepath|
        facter_dir_path = File.basename(File.dirname(filepath))

        content = File.open(filepath, 'rb') { |file| file.read }
        obj = JSON.parse(content)
        file_facter_version = obj['facterversion']

        expect(file_facter_version).to have_facter_version(facter_dir_path, filepath)
      end
    end
  end
end
