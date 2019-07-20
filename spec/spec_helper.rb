if ENV['COVERAGE'] == 'yes'
  require 'coveralls'
  Coveralls.wear!
end

require 'rspec'
require 'facterdb'
include FacterDB

def project_dir
  File.dirname File.dirname(File.expand_path(__FILE__))
end
