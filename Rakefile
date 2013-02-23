require 'rake'

task default: [:spec]

require 'rspec/core/rake_task'
desc 'Run specs'
RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec.rb'
end
