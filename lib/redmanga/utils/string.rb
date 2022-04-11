# rubocop:disable Style, Layout, Lint, Naming
# Adding style for string class
class String
	def black;          "\e[30m#{self}\e[0m"; end
	def red;            "\e[31m#{self}\e[0m"; end
	def green;          "\e[32m#{self}\e[0m"; end
	def brown;          "\e[33m#{self}\e[0m"; end
	def blue;           "\e[34m#{self}\e[0m"; end
	def magenta;        "\e[35m#{self}\e[0m"; end
	def cyan;           "\e[36m#{self}\e[0m"; end
	def grey;           "\e[37m#{self}\e[0m"; end
                                          ;
	def bg_black;       "\e[40m#{self}\e[0m"; end
	def bg_red;         "\e[41m#{self}\e[0m"; end
	def bg_green;       "\e[42m#{self}\e[0m"; end
	def bg_brown;       "\e[43m#{self}\e[0m"; end
	def bg_blue;        "\e[44m#{self}\e[0m"; end
	def bg_magenta;     "\e[45m#{self}\e[0m"; end
	def bg_cyan;        "\e[46m#{self}\e[0m"; end
	def bg_grey;        "\e[47m#{self}\e[0m"; end
                                          ;
	def bold;           "\e[1m#{self}\e[22m"; end
	def italic;         "\e[3m#{self}\e[23m"; end
	def underline;      "\e[4m#{self}\e[24m"; end
	def blink;          "\e[5m#{self}\e[25m"; end
	def reverse_colour;  "\e[7m#{self}\e[27m"; end

	def rgb(r, g, b);		"\e[38;2;#{r};#{g};#{b}m#{self}\e[0m";	end

	def clear_end!;			 self << "\e[0m"; end

	def black!;          self.insert(0, "\e[30m").clear_end!; end
	def red!;						 self.insert(0, "\e[31m").clear_end!; end
	def green!;					 self.insert(0, "\e[32m").clear_end!; end
	def brown!;					 self.insert(0, "\e[33m").clear_end!; end
	def blue!;					 self.insert(0, "\e[34m").clear_end!; end
	def magenta!;				 self.insert(0, "\e[35m").clear_end!; end
	def cyan!;					 self.insert(0, "\e[36m").clear_end!; end
	def grey!;					 self.insert(0, "\e[37m").clear_end!; end

	def bg_black!;       self.insert(0, "\e[40m").clear_end!; end
	def bg_red!;				 self.insert(0, "\e[41m").clear_end!; end
	def bg_green!;			 self.insert(0, "\e[42m").clear_end!; end
	def bg_brown!;			 self.insert(0, "\e[43m").clear_end!; end
	def bg_blue!;				 self.insert(0, "\e[44m").clear_end!; end
	def bg_magenta!;		 self.insert(0, "\e[45m").clear_end!; end
	def bg_cyan!;				 self.insert(0, "\e[46m").clear_end!; end
	def bg_grey!;				 self.insert(0, "\e[47m").clear_end!; end

	def bold!;           self.insert(0, "\e[1m") << "\e[22m"; end
	def italic!;				 self.insert(0, "\e[3m") << "\e[23m"; end
	def underline!;			 self.insert(0, "\e[4m") << "\e[24m"; end
	def blink!;					 self.insert(0, "\e[5m") << "\e[26m"; end
	def reverse_colour!; self.insert(0, "\e[7m") << "\e[27m"; end

	def no_colours!;		self.gsub /\e\[\d+m/, "";								end
end
