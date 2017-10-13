require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'facterdb'
include FacterDB

def project_dir
  File.dirname File.dirname(File.expand_path(__FILE__))
end
