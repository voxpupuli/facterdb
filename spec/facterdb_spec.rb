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

  describe 'database' do
    before(:each) do
      ENV['FACTERDB_SKIP_DEFAULTDB'] = nil
      FacterDB.instance_variable_set(:@database, nil)
    end

    it '#default_fact_files' do
      # This test is a little naive but works
      expect(FacterDB.default_fact_files.count).to be >= 1000
    end

    it '#facterdb_fact_files' do
      ENV['FACTERDB_SEARCH_PATHS'] = facts_24_path
      external_count = FacterDB.external_fact_files.count
      internal_count = FacterDB.default_fact_files.count
      # because we call unique on the array we remove the duplicates which skews this test
      expect(FacterDB.facterdb_fact_files.count).to eq(internal_count)
    end

    it '#database' do
      ENV['FACTERDB_SEARCH_PATHS'] = nil
      # to be an incomprehensible string
       expect(FacterDB.database).to be_a String
    end

    it '#database with external paths' do
      ENV['FACTERDB_SEARCH_PATHS'] = facts_24_path
      # to be an incomprehensible string
      expect(FacterDB.database).to be_a String
    end

    it 'without internal paths' do
      ENV['FACTERDB_SKIP_DEFAULTDB'] = 'true'
      ENV['FACTERDB_SEARCH_PATHS'] = nil
      expect(FacterDB.facterdb_fact_files).to eq([])
    end

    describe :windows do
      before(:each) do
        stub_const("File::PATH_SEPARATOR", ";")
        stub_const("File::ALT_SEPARATOR", '\\')
        stub_const("File::SEPARATOR", '/')
        allow(File).to receive(:directory?).and_return(true)
      end

      it '#external_fact_files with env variable and multiple paths' do
        ENV['FACTERDB_SEARCH_PATHS'] = [facts_24_path.gsub('/', '\\'), facts_23_path.gsub('/', '\\')].join(File::PATH_SEPARATOR)
        expect(FacterDB.external_fact_files.count).to eq(facts_24_count + facts_23_count)
      end

      it '#external_fact_files with env variable' do
        ENV['FACTERDB_SEARCH_PATHS'] = facts_24_path.gsub('/', '\\')
        expect(FacterDB.external_fact_files.count).to eq(facts_24_count)
      end

      it '#external_fact_files with argument' do
        ENV['FACTERDB_SEARCH_PATHS'] = nil
        path = facts_24_path.gsub('/', '\\')
        expect(FacterDB.external_fact_files(path).count).to eq(facts_24_count)
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
