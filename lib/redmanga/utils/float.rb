# frozen_string_literal: true

# Add extra functions to default class Float
class Float
	# Remove .0 if the float number is whole
	def prettify
		to_i == self ? to_i : self
	end
end
