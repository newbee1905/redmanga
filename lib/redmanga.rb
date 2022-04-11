# frozen_string_literal: true

require_relative "redmanga/utils/string"
require_relative "redmanga/utils/utils"
require_relative "redmanga/version"
require_relative "redmanga/redmanga"
require_relative "redmanga/cli"

module Redmanga
	class Error < StandardError; end
end
