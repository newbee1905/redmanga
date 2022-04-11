# frozen_string_literal: true

module RedManga
	# Enum for Manga Demographic
	module Demographic
		SHOUNEN, SHOUJO, SEINEN, JOSEI = *1..4
	end

	DEMOGRAPHIC = %w[Unknown Shounen Shoujo Seinen Josei].freeze
end
