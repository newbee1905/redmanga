# frozen_string_literal: true

require "rubygems"
require "gosu"

module RedManga
	BASE_WIDTH = 680
	BASE_HEIGHT = 960

	# The renderer for the selected chapter
	class RedMangaGui < Gosu::Window
		def initialize(pages)
			super BASE_WIDTH, BASE_HEIGHT, borderless: true, resizable: true

			# Make redrawing slower since the app don't need to update realtime
			# like normal video games
			self.update_interval = 120
			@old_width = BASE_WIDTH
			@old_height = BASE_HEIGHT

			@pages = pages
			@page_id = 0
			@page = @pages[@page_id]
		end

		def need_cusor?
			true
		end

		def update
			if @page.loaded
				# Redraw if @page is loaded
				# Switch it to false so not redrawing too much
				@page.loaded = false
				@old_width = width
				@old_height = height
				@page.update_image! width, height
			end
			return if @old_width == width && @old_height == height

			@old_width = width
			@old_height = height
			@page.update_image! width, height
		end

		def draw
			@page.draw width, height
		end

		def button_down(id)
			case id
			# Using mouse
			when Gosu::MsLeft
				if mouse_x < width / 2
					prev_page
				else
					next_page
				end
			# Normal, WASD, and VIM-like keybinding
			when Gosu::KbLeft, Gosu::KbA, Gosu::KbH
				prev_page
			when Gosu::KbRight, Gosu::KbD, Gosu::KbL
				next_page
			when Gosu::KbEscape, Gosu::KbQ
				close
			end
		end

		# Move back one page
		def prev_page
			@page_id -= 1 unless @page_id.zero?
			@page = @pages[@page_id]
			@page.update_image! width, height
		end

		# Move forward one page
		def next_page
			return if @page_id == @pages.length - 1

			@page_id += 1
			@page = @pages[@page_id]
			@page.update_image! width, height
		end
	end
end
