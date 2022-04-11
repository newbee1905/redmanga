# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"

RuboCop::RakeTask.new :lint do |task|
	task.patterns = ["lib/**/*.rb", "test/**/*.rb"]
	task.options << "--auto-correct"
	task.fail_on_error = false
end

task default: %i[lint]
