require 'optparse'

module RedMangadex
	class CLI
		def initialize
			@options = {}

			OptionParser.new do |opts|
				opts.banner = "Usage: redmangadex [options]"

				opts.on("-v", "--[no-]verbose", "Show extra information") do |v|
					@options[:verbose] = v 
				end

			end.parse!

			if @options[:verbose]
				puts "Options: #{@options.inspect}"
				puts "ARGV: #{ARGV.inspect}"
			end
		end
	end
end
