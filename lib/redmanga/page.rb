# frozen_string_literal: true

require "rubygems"
require "gosu"
require "rmagick"
require "httparty"
require "concurrent"

module RedManga
	IMAGE_CDN = "https://meo%s.comick.pictures/%s"

	# Get the image from the cdn url
	# Resize the image using rmagick since it
	# gives better result compare to gosu scaling
	# returning empty white backgroud if the image is unloadable
	class MangaPage
		include Concurrent::Async
		attr_accessor :url, :file_name, :width, :height, :loaded

		def initialize(file_name, width, height)
			@file_name = file_name
			@width = width
			@height = height
			# Showing loading or non-loadable page
			@loading_blob = Magick::Image.new width, height, Magick::SolidFill.new("white")
			@blob = @loading_blob
			@loaded = false
		end

		def page
			cdn_id = 1
			begin
				@url = format(IMAGE_CDN, cdn_id == 1 ? "" : cdn_id.to_s, file_name)
				res = HTTParty.get @url
				@blob = Magick::Image.from_blob(res.body).first
				@loaded = true
			rescue Magick::ImageMagickError
				# the cdn has 4 links -> cycle through 4
				# If all 4 are non existed -> broken image
				# -> Use a blank white page
				cdn_id += 1
				retry if cdn_id <= 3

				@url = ""

				@blob = @loading_blob
			end
		end

		# Run when Gosu is resized
		def update_image!(win_width, win_height)
			@resized_blob = @blob.resize_to_fit(win_width, win_height)
			@x = win_width / 2 - @resized_blob.columns / 2
			@y = win_height / 2 - @resized_blob.rows / 2
			@img = Gosu::Image.new @resized_blob
		end

		def draw(_win_width, _win_height)
			update_image! if @img.nil?
			@img.draw @x, @y, 0, 1.0, 1.0
		end
	end
end
