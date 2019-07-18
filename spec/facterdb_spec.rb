require 'spec_helper'

describe 'FacterDB' do

  describe 'database' do
    let(:facts_24_path)  { File.join(project_dir, 'facts', '2.4') }
    let(:facts_24_count) { Dir.glob(File.join(facts_24_path,'*.facts')).count }
    let(:facts_23_path)  { File.join(project_dir, 'facts', '2.3') }
    let(:facts_23_count) { Dir.glob(File.join(facts_23_path,'*.facts')).count }

    before(:each) do
      ENV['FACTERDB_SKIP_DEFAULTDB'] = nil
      FacterDB.instance_variable_set(:@database, nil)
    end

    it 'skip default facts' do
      ENV['FACTERDB_SKIP_DEFAULTDB'] = 'true'
      expect(FacterDB.use_defaultdb?).to eq(false)
    end

    it 'use default facts' do
      expect(FacterDB.use_defaultdb?).to eq(true)
    end

    it '#external_fact_files with env variable' do
      ENV['FACTERDB_SEARCH_PATHS'] = facts_24_path
      expect(FacterDB.external_fact_files.count).to eq(facts_24_count)
    end

    it '#external_fact_files with env variable and multiple paths' do
      ENV['FACTERDB_SEARCH_PATHS'] = [facts_24_path, facts_23_path].join(File::PATH_SEPARATOR)
      expect(FacterDB.external_fact_files.count).to eq(facts_24_count + facts_23_count)
    end

    it '#external_fact_files with argument' do
      ENV['FACTERDB_SEARCH_PATHS'] = nil
      expect(FacterDB.external_fact_files(facts_24_path).count).to eq(facts_24_count)
    end

    it '#external_fact_files without argument or env variable' do
      ENV['FACTERDB_SEARCH_PATHS'] = nil
      expect(FacterDB.external_fact_files.count).to be 0
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

  describe '#get_os_facts' do
    context 'without parameters' do
      subject { FacterDB.get_os_facts() }
      it "Should return an array of hashes with at least 1 element" do
        expect(subject.class).to eq Array
        expect(subject.size).not_to eq(0)
        expect(subject.select { |facts| facts.class != Hash }.size).to eq(0)
      end
    end

    context 'without parameters' do
      subject { FacterDB.get_os_facts() }
      it "Should return an array of hashes with at least 1 element" do
        expect(subject.class).to eq Array
        expect(subject.size).not_to eq(0)
        expect(subject.select { |facts| facts.class != Hash }.size).to eq(0)
      end
    end

    context 'with an Array filter' do
      subject { FacterDB.get_os_facts('*', [{:osfamily => 'Debian'}]) }
      it "Should return an array of hashes with at least 1 element" do
        expect(subject.class).to eq Array
        expect(subject.size).not_to eq(0)
        expect(subject.select { |facts| facts.class != Hash }.size).to eq(0)
      end
    end

    context 'with a Hash filter' do
      subject { FacterDB.get_os_facts('*', {:osfamily => 'Debian'}) }
      it "Should return an array of hashes with at least 1 element" do
        expect(subject.class).to eq Array
        expect(subject.size).not_to eq(0)
        expect(subject.select { |facts| facts.class != Hash }.size).to eq(0)
      end
    end

    context 'with a String filter' do
      subject { FacterDB.get_os_facts('*', 'osfamily=Debian') }
      it "Should return an array of hashes with at least 1 element" do
        expect(subject.class).to eq Array
        expect(subject.size).not_to eq(0)
        expect(subject.select { |facts| facts.class != Hash }.size).to eq(0)
      end
    end
  end

  describe '#get_facts' do
    context 'without parameters' do
      subject { FacterDB.get_facts() }
      it "Should return an array of hashes with at least 1 element" do
        expect(subject.class).to eq Array
        expect(subject.size).not_to eq(0)
        expect(subject.select { |facts| facts.class != Hash }.size).to eq(0)
      end
    end

    context 'with an Array filter' do
      subject { FacterDB.get_facts([{:osfamily => 'Debian'}]) }
      it "Should return an array of hashes with at least 1 element" do
        expect(subject.class).to eq Array
        expect(subject.size).not_to eq(0)
        expect(subject.select { |facts| facts.class != Hash }.size).to eq(0)
      end
    end

    context 'with a Hash filter' do
      subject { FacterDB.get_facts({:osfamily => 'Debian'}) }
      it "Should return an array of hashes with at least 1 element" do
        expect(subject.class).to eq Array
        expect(subject.size).not_to eq(0)
        expect(subject.select { |facts| facts.class != Hash }.size).to eq(0)
      end
    end

    context 'with a String filter' do
      subject { FacterDB.get_facts('osfamily=Debian') }
      it "Should return an array of hashes with at least 1 element" do
        expect(subject.class).to eq Array
        expect(subject.size).not_to eq(0)
        expect(subject.select { |facts| facts.class != Hash }.size).to eq(0)
      end
    end
  end
end
