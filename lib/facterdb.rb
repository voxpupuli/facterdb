require 'facter'

module FacterDB

  def get_os_facts
    facts_dir = File.expand_path(File.join(File.dirname(__FILE__), '../facts'))
    ret = []
    Dir.glob("#{facts_dir}/*/*.facts") do |file|
      ret << JSON.parse(IO.read(file), :symbolize_names => true)
    end
    ret
  end
end
