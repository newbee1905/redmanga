# frozen_string_literal: true

require_relative "utils/string"
require_relative "demographic"

module RedManga
	# Manga's information -> group it together as a class incase need to use it
	class Manga
		attr_accessor :title, :slug, :id, :mdid, :bayesian_rating, :demographic, :lang, :desc

		def initialize(title, slug, id, _mid, bayesian_rating, demographic, lang, desc)
			@title = title
			@slug = slug
			@id = id
			@mdid = mdid
			@bayesian_rating = bayesian_rating
			@demographic = demographic || 0
			@lang = lang
			@desc = desc
		end

		def self.from_json(json)
			new(
				json[:title],
				json[:slug],
				json[:id],
				json[:mdid],
				json[:bayesian_rating],
				json[:demographic],
				json[:lang_name],
				json[:desc]
			)
		end

		def info
			puts "#{"ID:".bold.green} #{@id}"
			puts "#{"Title:".bold.green} #{@title}"
			puts "#{"Bayesian Rating:".bold.green} #{@bayesian_rating}"
			puts "#{"Demographic:".bold.green} #{DEMOGRAPHIC[@demographic]}"
			puts "#{"Native Lang:".bold.green} #{@lang}"
			puts "#{"Description:".bold.green} #{@desc}"
		end
	end
end
