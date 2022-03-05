# frozen_string_literal: true

require_relative "lib/redmangadex/version"

Gem::Specification.new do |spec|
	repo = "https://github.com/newbee1905/redmangadex"

  spec.name = "redmangadex"
  spec.version = RedMangadex::VERSION
  spec.authors = ["newbee1905", "Le Minh Vu"]
	spec.email = ["beenewminh@outlook.com", "vuleminh190503@hotmail.com", "vugia.leminh1905@gmail.com"]

  spec.summary = "Read Manga from CLI with Mangadex's api"
  spec.description = "Read Manga from CLI with Mangadex's api"
	spec.homepage = repo
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = repo
	spec.metadata["changelog_uri"] = "#{repo}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
	spec.executables = spec.files.map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
	spec.add_dependency "httparty", "~> 0.17.3"
	spec.add_development_dependency "rake", "~> 13.0"
	spec.add_development_dependency "minitest", "~> 5.0"
	spec.add_development_dependency "rubocop", "~> 1.21"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
