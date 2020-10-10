require 'spec_helper'

describe FacterDB do
  shared_examples 'returns a result' do
    it 'returns an Array' do
      expect(result).to be_an_instance_of(Array)
    end

    it 'returns at least 1 result' do
      expect(result).not_to be_empty
    end

    it 'returns an Array of Hashes' do
      expect(result).to all(be_an_instance_of(Hash))
    end
  end

  let(:facts_24_path)  { File.join(project_dir, 'facts', '2.4') }
  let(:facts_24_count) { Dir.glob(File.join(facts_24_path,'*.facts')).count }
  let(:facts_23_path)  { File.join(project_dir, 'facts', '2.3') }
  let(:facts_23_count) { Dir.glob(File.join(facts_23_path,'*.facts')).count }

  describe '.use_defaultdb?' do
    subject { described_class.use_defaultdb? }

    before(:each) do
      ENV.delete('FACTERDB_SKIP_DEFAULTDB')
    end

    context 'when FACTERDB_SKIP_DEFAULTDB environment variable is unset' do
      it { is_expected.to be_truthy }
    end

    context 'when FACTERDB_SKIP_DEFAULTDB environment variable is set' do
      before(:each) do
        ENV['FACTERDB_SKIP_DEFAULTDB'] = '1'
      end

      it { is_expected.to be_falsey }
    end
  end

  describe '.external_fact_files' do
    subject(:file_count) { described_class.external_fact_files.count }

    let(:non_directory_path) { File.join('this', 'is', 'not', 'a', 'directory') }

    before(:each) do
      ENV.delete('FACTERDB_SEARCH_PATHS')
      allow(File).to receive(:directory?).and_call_original
      allow(File).to receive(:directory?).with(non_directory_path).and_return(false)
    end

    context 'without an argument or FACTERDB_SEARCH_PATHS environment variable set' do
      it { is_expected.to be_zero }
    end

    context 'when the FACTERDB_SEARCH_PATHS environment variable is set' do
      it 'supports a single path' do
        ENV['FACTERDB_SEARCH_PATHS'] = facts_24_path

        expect(file_count).to eq(facts_24_count)
      end

      it 'supports multiple paths delimited by the OS path separator' do
        ENV['FACTERDB_SEARCH_PATHS'] = [facts_24_path, facts_23_path].join(File::PATH_SEPARATOR)

        expect(file_count).to eq(facts_24_count + facts_23_count)
      end

      it 'ignores paths that are not a directory' do
        ENV['FACTERDB_SEARCH_PATHS'] = [facts_24_path, non_directory_path].join(File::PATH_SEPARATOR)

        object = defined?(Warning) ? Warning : Kernel
        allow(object).to receive(:warn).and_call_original
        allow(object).to receive(:warn).with(a_string_matching(%r{is not a directory}))

        expect(file_count).to eq(facts_24_count)
      end
    end

    # TODO: There is no parameter validation in this method
    context 'when passed an argument' do
      subject(:file_count) { described_class.external_fact_files(fact_paths).count }

      context 'that is a single path' do
        let(:fact_paths) { facts_24_path }

        it 'returns the paths to the fact sets in the specified path' do
          expect(file_count).to eq(facts_24_count)
        end
      end

      context 'that is multiple paths delimited by the OS path separator' do
        let(:fact_paths) { [facts_24_path, facts_23_path].join(File::PATH_SEPARATOR) }

        it 'returns the paths to the fact sets in all the specified paths' do
          expect(file_count).to eq(facts_24_count + facts_23_count)
        end
      end

      context 'that contains a path that is not a directory' do
        let(:fact_paths) { [facts_24_path, non_directory_path].join(File::PATH_SEPARATOR) }

        it 'ignores the path that is not a directory' do
          object = defined?(Warning) ? Warning : Kernel
          allow(object).to receive(:warn).and_call_original
          allow(object).to receive(:warn).with(a_string_matching(%r{is not a directory}))

          expect(file_count).to eq(facts_24_count)
        end
      end
    end
  end

  describe '.default_fact_files' do
    subject(:default_fact_files) { described_class.default_fact_files }

    before(:each) do
      ENV.delete('FACTERDB_SKIP_DEFAULTDB')
    end

    context 'when FACTERDB_SKIP_DEFAULTDB environment variable is not set' do
      it 'returns the list of fact sets included in FacterDB' do
        # This test is a little naive but works
        expect(default_fact_files.count).to be >= 1000
      end
    end

    context 'when FACTERDB_SKIP_DEFAULTDB environment variable is set' do
      before(:each) do
        ENV['FACTERDB_SKIP_DEFAULTDB'] = '1'
      end

      it { is_expected.to be_empty }
    end
  end

  describe '.facterdb_fact_files' do
    subject(:facterdb_fact_files) { described_class.facterdb_fact_files }

    before(:each) do
      ENV.delete('FACTERDB_SKIP_DEFAULTDB')
    end

    after(:each) do
      ENV.delete('FACTERDB_SEARCH_PATHS')
    end

    it 'returns the deduplicated combination of .default_fact_files and .external_fact_files' do
      ENV['FACTERDB_SEARCH_PATHS'] = facts_24_path

      expect(facterdb_fact_files.count).to eq(described_class.default_fact_files.count)
    end

    context 'with no loaded fact sets' do
      before(:each) do
        ENV['FACTERDB_SKIP_DEFAULTDB'] = '1'
        ENV.delete('FACTERDB_SEARCH_PATHS')
      end

      it { is_expected.to be_empty }
    end
  end

  describe '.database' do
    subject(:database) { described_class.database }

    before(:each) do
      ENV.delete('FACTERDB_SKIP_DEFAULTDB')
      ENV.delete('FACTERDB_SEARCH_PATHS')
      FacterDB.instance_variable_set(:@database, nil)
    end

    it 'returns a String' do
      expect(database).to be_an_instance_of(String)
    end

    it 'is parsable JSON' do
      expect { JSON.parse(database) }.not_to raise_error
    end

    context 'when FACTERDB_INJECT_SOURCE environment variable is set' do
      subject(:json_database) { JSON.parse(database) }

      before(:each) do
        ENV['FACTERDB_INJECT_SOURCE'] = '1'
      end

      it 'contains a "_facterdb_filename" key in each fact set' do
        expect(json_database).to all(include('_facterdb_filename' => anything))
      end

      it 'contains a "_facterdb_path" key in each fact set' do
        expect(json_database).to all(include('_facterdb_path' => anything))
      end
    end
  end

  describe '.get_os_facts' do
    subject(:result) { FacterDB.get_os_facts(facter_version, filter) }

    before(:each) do
      object = defined?(Warning) ? Warning : Kernel
      allow(object).to receive(:warn).and_call_original
      allow(object).to receive(:warn).with(a_string_matching(%r{`get_os_facts` is deprecated}))
    end

    context 'without parameters' do
      subject(:result) { FacterDB.get_os_facts() }

      include_examples 'returns a result'
    end

    context 'when matching all Facter versions' do
      let(:facter_version) { '*' }

      context 'with an Array filter' do
        let(:filter) { [{ :osfamily => 'Debian' }] }

        include_examples 'returns a result'
      end

      context 'with a Hash filter' do
        let(:filter) { { :osfamily => 'Debian' } }

        include_examples 'returns a result'
      end

      context 'with a String filter' do
        let(:filter) { 'osfamily=Debian' }

        include_examples 'returns a result'
      end

      context 'with a filter of an unsupported type' do
        let(:filter) { true }

        it 'raises an error' do
          expect { result }.to raise_error(%r{filter must be either})
        end
      end
    end

    context 'when matching a specific facter version' do
      let(:facter_version) { '2.4.0' }

      shared_examples 'returns only the specified version' do
        it 'only includes fact sets for the specified version' do
          expect(result).to all(include(:facterversion => match(%r{\A2\.4})))
        end
      end

      context 'with an Array filter' do
        let(:filter) { [{ :osfamily => 'Debian' }] }

        include_examples 'returns a result'
        include_examples 'returns only the specified version'
      end

      context 'with a Hash filter' do
        let(:filter) { { :osfamily => 'Debian' } }

        include_examples 'returns a result'
        include_examples 'returns only the specified version'
      end

      context 'with a String filter' do
        let(:filter) { 'osfamily=Debian' }

        include_examples 'returns a result'
        include_examples 'returns only the specified version'
      end

      context 'with a filter of an unsupported type' do
        let(:filter) { true }

        it 'raises an error' do
          expect { result }.to raise_error(%r{filter must be either})
        end
      end
    end
  end

  describe '.valid_filters?' do
    it 'invalid and false' do
      expect( FacterDB.valid_filters?('and')).to be_falsey
    end

    it 'valid and true' do
      expect( FacterDB.valid_filters?('foo')).to be_truthy
    end
  end

  describe '.generate_filter_str' do
    it 'invalid type' do
      expect{FacterDB.generate_filter_str(3)}.to raise_error(FacterDB::Errors::InvalidFilter)
    end

    it 'with string' do
      expect(FacterDB.generate_filter_str('foo')).to eq("foo")
    end

    it 'with hash' do
        expect(FacterDB.generate_filter_str({:osfamily => 'Debian'})).to eq("osfamily=Debian")
    end

    it 'with Array' do
      expect(FacterDB.generate_filter_str([:osfamily => 'Debian'])).to eq("(osfamily=Debian)")
    end

    it 'empty' do
      expect(FacterDB.generate_filter_str('')).to eq('')
    end

    it 'nil filter' do
      expect(FacterDB.generate_filter_str(nil)).to eq('')
    end
  end

  describe '.get_facts' do
    subject(:result) { FacterDB.get_facts(filter) }

    let(:filter) { nil }

    context 'without parameters' do
      include_examples "returns a result"
    end

    context 'with an Array filter' do
      let(:filter) { [:osfamily => 'Debian'] }

      include_examples "returns a result"
    end

    context 'with a Hash filter' do
      let(:filter) { { :osfamily => 'Debian' } }

      include_examples "returns a result"
    end

    context 'with a String filter' do
      let(:filter) { 'osfamily=Debian' }

      include_examples "returns a result"
    end

    context 'with a filter of an unsupported type' do
      let(:filter) { true }

      it 'raises an error' do
        expect { result }.to raise_error(%r{filter must be either})
      end
    end
  end
end
