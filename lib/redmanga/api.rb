# frozen_string_literal: true

require "rubygems"
require "httparty"
require "rmagick"
require "json"
require "gosu"
require_relative "manga"
require_relative "demographic"

module RedManga
	# Using ComickFun API to get manga, chapter, page
	class ComickFun
		include HTTParty
		base_uri "https://api.comick.fun"

		def initialize
			@opts = { format: :plain, query: {} }
			@image_cdn = "https://meo%s.comick.pictures/file/comick/%s"
		end

		def search(query = {})
			# Get the options from User"s input
			@opts[:query] = query

			res = self.class.get "/search", @opts
			JSON.parse res.body, symbolize_names: true
		end

		def manga(slug)
			res = self.class.get "/comic/#{slug}"
			JSON.parse res.body, symbolize_names: true
		end

		def chapter(manga_id, chap, _lang = "en")
			res = self.class.get "/comic/#{manga_id}/chapter", { query: { lang: "en", chap: chap } }
			JSON.parse res.body, symbolize_names: true
		end

		def chapter_content(chapter_hid)
			res = self.class.get "/chapter/#{chapter_hid}"
			JSON.parse res.body, symbolize_names: true
		end

		def page(file_name)
			cdn_id = 1
			begin
				url = format(@image_cdn, cdn_id == 1 ? "" : cdn_id.to_s, file_name)
				@res = HTTParty.get url
				@blob = Magick::Image.from_blob(@res.body).first.resize_to_fit
				Gosu::Image.new @blob
			rescue Magick::ImageMagickError
				cdn_id += 1
				retry if cdn_id <= 3

				Gosu::Image.new "blank.png"
			end
		end
	end
end
