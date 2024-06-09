# frozen_string_literal: true

require 'spec_helper'
require 'digest'
require 'pathname'
require 'json_schemer'

schema = {
  '$id': 'https://voxpupuli.org/facterdb/factset.schema.json',
  title: 'Factset',
  description: 'A saved puppet facter factset',

  'type' => 'object',

  properties: {
    aio_agent_version: { 'type' => 'string' },
    os: {
      type: 'object',
      properties: {
        family: { enum: %w[RedHat Debian Gentoo windows OpenBSD Archlinux Suse FreeBSD Darwin Solaris] },
      },
    },
  },

  #  "required": ["_meta_generation_date"],

  allOf: [
    {
      if: { properties: { os: { properties: { family: { enum: ['Debian'] } } } } },
      then: { required: ['aio_agent_version'] },
      #      'else': { 'required': ["aio_agent_version"] }
    },
  ],
}

schemer = JSONSchemer.schema(schema)
RSpec::Matchers.define :be_valid_json do
  match do |actual|
    content = File.binread(actual)
    begin
      JSON.parse(content)
      true
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

describe 'Factset Schemas are Valid', type: :feature do
  before do
    ENV['FACTERDB_SKIP_DEFAULTDB'] = nil
    FacterDB.instance_variable_set(:@database, nil)
  end

  project_dir = Pathname.new(__dir__).parent
  FacterDB.default_fact_files.each do |filepath|
    relative_path = Pathname.new(filepath).relative_path_from(project_dir).to_s
    describe relative_path do
      subject(:content) do
        JSON.parse(File.binread(filepath))
      end

      it 'contains a valid JSON document' do
        expect(filepath).to be_valid_json
      end

      it 'contains a fact set which matches the facter version' do
        facter_dir_path = File.basename(File.dirname(filepath))

        expect(content['facterversion']).to have_facter_version(facter_dir_path, filepath)
      end

      it 'matches the schema' do
        valid_json = schemer.validate(content).to_a
        expect(valid_json).to be_empty
      end
    end
  end
end
