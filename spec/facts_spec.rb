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
  end

  KNOWN_IPADDRESS_PENDING = {
    'facts/1.6/fedora-19-i386.facts' => 'unable to regenerate facts',
    'facts/1.6/fedora-19-x86_64.facts' => 'unable to regenerate facts',
    'facts/2.1/archlinux-x86_64.facts' => 'no ifconfig package',
    'facts/3.10/ubuntu-18.04-aarch64.facts' => 'unable to regenerate facts',
    'facts/1.6/archlinux-x86_64.facts' => 'no ifconfig package',
    'facts/2.4/archlinux-x86_64.facts' => 'no ifconfig package',
    'facts/3.2/aix-61-powerpc.facts' => 'unable to regenerate facts',
    'facts/3.2/aix-71-powerpc.facts' => 'unable to regenerate facts',
    'facts/3.2/aix-53-powerpc.facts' => 'unable to regenerate facts',
    'facts/2.3/archlinux-x86_64.facts' => 'no ifconfig package',
    'facts/2.5/archlinux-x86_64.facts' => 'no ifconfig package',
    'facts/1.7/archlinux-x86_64.facts' => 'no ifconfig package',
    'facts/2.0/archlinux-x86_64.facts' => 'no ifconfig package',
    'facts/2.2/archlinux-x86_64.facts' => 'no ifconfig package',
    'facts/3.6/pcs-6-x86_64.facts' => 'unable to regenerate facts',
    'facts/3.0/ubuntu-15.10-x86_64.facts' => 'no puppet-agent package',
    'facts/3.0/ubuntu-15.10-i386.facts' => 'no puppet-agent package',
  }

  project_dir = Pathname.new(__dir__).parent
  FacterDB.default_fact_files.each do |filepath|
    relative_path = Pathname.new(filepath).relative_path_from(project_dir).to_s
    describe relative_path do
      subject(:content) do
        JSON.parse(File.open(filepath, 'rb') { |file| file.read })
      end

      it 'contains a valid JSON document' do
        expect(filepath).to be_valid_json
      end

      it 'contains a fact set which matches the facter version' do
        facter_dir_path = File.basename(File.dirname(filepath))

        expect(content['facterversion']).to have_facter_version(facter_dir_path, filepath)
      end

      it 'contains an ipaddress fact' do
        pending KNOWN_IPADDRESS_PENDING[relative_path] if KNOWN_IPADDRESS_PENDING.key?(relative_path)
        expect(content['ipaddress']).to not_be_nil.and not_be_empty
      end
    end
  end
end
