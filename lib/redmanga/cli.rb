# frozen_string_literal: true

require "logger"
require "optparse"
require "set"
require_relative "command"
require_relative "api"
require_relative "manga"
require_relative "page"
require_relative "redmanga"
require_relative "utils/float"

module RedManga
	# Main process manager for the tool
	# Process everything for the cli
	class CLI
		def initialize
			puts "This Cli tool is using Comickfun API".bold.underline.green

			@cache_dir = "#{Dir.home}/.cache/redmanga"
			@log_file = "#{Dir.home}/.local/share/redmanga.log"
			@comickfun = ComickFun.new
			@cmd = "search" # default action is search
			@commands = {}

			setup_commands
			parse
			setup_loggger
			setup_cache

			@log&.info { "OPTS: #{@opts.inspect}" }
			@log&.info { "ARGV: #{ARGV.inspect}" }
			@log&.info { "Genres: #{@manga_opts[:genres]}" } if @manga_opts[:genres].length.positive?
			@log&.info { "Excludes: #{@manga_opts[:excludes]}" } if @manga_opts[:excludes].length.positive?
			@log&.info { "Tags: #{@manga_opts[:tags]}" } if @manga_opts[:tags].length.positive?
			@log&.info { "Country: #{@manga_opts[:country]}" } if @manga_opts[:country].length.positive?
		end

		# Main function
		def run
			print_version if @opts[:version]

			case ARGV.length
			when 0
				print "Enter Manga name: "
				@cmd_args = [gets.chomp]
				@log&.info { "Input Manga: #{@manga_name}" }
			when 1
				if ARGV[0] == "help" || ARGV[0] == "version"
					@cmd = ARGV[0]
					@cmd_args = []
				else
					@cmd_args = ARGV
					@log&.info { "Input Manga: #{@manga_name}" }
				end
			else
				@cmd = ARGV[0]
				@cmd_args = ARGV[1..]
				@log&.info { "Command: #{@cmd}" }
				@log&.info { "Input: #{@cmd_args.inspect}" }
			end

			@commands[@cmd].run(*@cmd_args)
		end

		private

		# Parsing options
		def parse
			@opts = { verbose: 1 }
			@manga_opts = { genres: Set.new, excludes: Set.new, tags: Set.new, country: Set.new }

			begin
				@parser = OptionParser.new do |opt|
					opt.banner = "Usage: redmanga [opts] [commands]".blue
					opt.separator ""
					opt.separator "opts:".blue
					opt.on("-V", "--version", "Display current version.") { @opts[:version] = true }
					opt.on("-v", "--[no-]verbose", "Show extra information.") { |v| @opts[:verbose] = (v ? 2 : 0) }
					opt.on("-g", "--genres genre", "Filter Manga's genres.") { |genre| @manga_opts[:genres] << genre }
					opt.on("-G", "--excludes-genres genre", "Exclude Manga's genres.") { |genre| @manga_opts[:excludes] << genre }
					opt.on("-T", "--tags tag", "Filter Manga's tags.") { |tag| @manga_opts[:tags] << tag }
					opt.on("-c", "--country country", "Filter Manga's country.") { |country| @manga_opts[:country] << country }
					opt.on("-f", "--from year", "Only show Mangas from this year.") { |year| @manga_opts[:from] = year }
					opt.on("-t", "--to year", "Only show Mangas to this year.") { |year| @manga_opts[:to] = year }
					opt.on("-T", "--time days", "Only show Mangas in given days forward.") { |days| @manga_opts[:time] = days }
					opt.on("-C", "--completed", "Only show Mangas in given days forward.") { @manga_opts[:completed] = true }
					opt.separator ""
					opt.separator "commands:".blue
				end
				@parser.parse!
			rescue OptionParser::InvalidOption
				err "Invalid option for redmanga."
				print_help
				exit 1
			end
		end

		# Add colour to severity for stdout log
		def fmt_stdout_log(severity, msg)
			pretty_severity = severity.bold
			case severity
			when "DEBUG"
				pretty_severity.cyan!
			when "INFO"
				pretty_severity.green!
			when "WARN"
				pretty_severity.yellow!
			when "ERROR"
				pretty_severity.brown!
			when "FATAL"
				pretty_severity.red!
			else
				pretty_severity.blue!
			end
			pretty_severity << " " << msg
		end

		# Setup logger base on verbose level
		def setup_loggger
			return if @opts[:verbose].zero?

			@log = Logger.new @log_file
			@log.formatter = proc do |severity, datetime, _, msg|
				puts fmt_stdout_log severity, msg if @opts[:verbose] == 2
				"[#{datetime}] #{severity}:\t#{msg}\n"
			end
		end

		# Creating .cache/redmanga folder if not exist
		def setup_cache
			return if Dir.exist? @cache_dir

			begin
				Dir.mkdir @cache_dir
				@log&.info { "Success making cache dir for redmanga" }
			rescue SystemCallError
				@log&.fatal { "Can't create cache dir for redmagnadex" }
				exit 1
			end
		end

		def setup_commands
			@commands["search"] = Command.new("search", proc do |manga_name|
				@manga_opts[:q] = manga_name
				manga_slug = select_manga[:slug]
				chapter = (select_chapter (@comickfun.manga manga_slug)[:comic])[:chapter]
				pages = chapter[:md_images].map do |image|
					page = MangaPage.new(image[:b2key], image[:w], image[:h])
					page.async.page
					page
				end

				RedMangaGui.new(pages).show
				puts "Finished Reading".blue
			end, "The command show list of mangas with the input name and open the selected it\n`redmanga search {name}`\nReplace {name} with the name you want to searched.\nIf no command was input, this command will be default")
			@commands["info"] = Command.new("info", proc do |manga_name|
				@manga_opts[:q] = manga_name
				manga_slug = select_manga[:slug]
				manga = Manga.from_json((@comickfun.manga manga_slug)[:comic])
				manga.info
			end, "The command show list of mangas with the input name and show its info\n`redmanga info {name}`\nReplace {name} with the name you want to searched.")
			# @commands["download"] = Command.new("download", proc do |manga_name, output_dir = "./"|
			# 	puts manga_name
			# end, "The command show list of mangas with the input name and download the selected chapter\n`redmanga download {name}`\nReplace {name} with the name you want to searched.")
			@commands["version"] = Command.new("version", -> { print_version }, "Show version")
			@commands["help"] = Command.new("help", -> { print_help }, "Show help menu")
		end

		def select_manga
			mangas = @comickfun.search @manga_opts
			mangas.each_with_index do |manga, i|
				id = "[#{i + 1}]".bold
				message = "#{manga[:title]} (#{manga[:rating] || 0})"
				if (i & 1).zero?
					puts "#{id} #{message}".blue
				else
					puts "#{id} #{message}".cyan
				end
			end
			puts "#{"[q]".bold} quit".red
			begin
				print " > ".magenta
				inp = $stdin.gets.chomp
				exit 0 if inp == "q"
				inp = Integer inp
				raise ArgumentError if inp > mangas.length || inp <= 0

				mangas[inp - 1]
			rescue ArgumentError
				puts "Please only select listed option.".bold.red
				retry
			end
		end

		def select_chapter(manga)
			puts "The latest chapter is #{manga[:last_chapter]}.".green
			puts "Please select a chapter. Or type `q` to quit.".underline.brown
			begin
				print " > ".magenta
				inp = $stdin.gets.chomp
				exit 0 if inp == "q"
				inp = Float inp
				chapters = (@comickfun.chapter manga[:id], inp.prettify)[:chapters]
				if chapters.empty?
					puts "There are no chapter #{inp} for manga #{manga[:title]}"
					exit 1
				else
					@comickfun.chapter_content chapters[0][:hid]
				end
			rescue ArgumentError => e
				p e
				puts "Please only select listed option."
				retry
			end
		end

		def print_commands_help
			@commands.each_value { |command| command.help 1 }
		end

		def print_help
			puts @parser.help
			print_commands_help
		end

		def print_version
			puts "redmanga's current version is #{RedManga::VERSION}"
			exit 0
		end
	end
end
