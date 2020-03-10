require_relative "app/environment"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

Dir.glob("lib/tasks/*.rake").each { |r| load r }

task default: %i[spec]
