# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new :test do |task|
  task.libs << "test"
  task.libs << "lib"
  task.test_files = FileList["test/**/test_*.rb"]
end

require 'rubocop/rake_task'

RuboCop::RakeTask.new :lint do |task|
	task.patterns = ['lib/**/*.rb', 'test/**/*.rb']
	task.fail_on_error = false
end

task default: %i[test lint]
