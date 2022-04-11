# frozen_string_literal: true

module RedManga
	# For running cli command
	class Command
		def initialize(name, proc, description = nil)
			@name = name
			@actions = proc
			@description = description || name
		end

		# Run the command with given args
		# Catch the errors and print out help message
		def run(*args)
			@actions.call(*args)
		rescue StandardError => e
			if e.instance_of? ArgumentError
				err "Wrong format for command `#{@name}`\n"
			else
				err_ e
			end
			help
			exit 0
		end

		def help(indent = 0)
			puts " " * 4 * indent << "#{@name.green}:"
			@description
				.split("\n")
				.each { |line| puts " " * 4 * (indent + 1) << line }
		end
	end
end
