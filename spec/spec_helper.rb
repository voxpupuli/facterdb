if ENV['COVERAGE'] == 'yes'
  require 'coveralls'
  require 'simplecov'

  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  SimpleCov.start do
    add_filter %r{^/spec/}
  end
end

require 'rspec'
require 'facterdb'
include FacterDB

RSpec::Matchers.define_negated_matcher :not_be_nil, :be_nil
RSpec::Matchers.define_negated_matcher :not_be_empty, :be_empty
RSpec::Matchers.define_negated_matcher :not_include, :include

def project_dir
  File.dirname(File.expand_path(__FILE__), 2)
end
