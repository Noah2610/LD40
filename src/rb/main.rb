
$screen = {
	w: 860,
	h: 640
}

#$images = {
#	sections: {
#		placeholder: "#{$dir[:images]}/section_placeholder.png"
#	}
#}


def load_sections directory
	ret = []

	dir_parent = Dir.new directory
	dir_parent.each do |parent|
		next  if (/\A\.{1,2}\z/ =~ parent)
		png = nil
		conf = nil
		Dir.new("#{directory}/#{parent}").each do |file|
			next  if (file == "." || file == "..")
			png = "#{dir_parent.path}/#{parent}/#{file}"   if (/\A.*\.png\z/ =~ file)
			conf = "#{dir_parent.path}/#{parent}/#{file}"  if (/\A.*\.conf\.rb\z/ =~ file)
		end

		puts parent, "png: " + png, "conf: " + conf
		# add section data if .png and .conf.rb are present
		if (File.exists?(png) && File.exists?(conf))
			ret << {
				name:    parent.to_sym,
				image:   Gosu::Image.new(png, rect: [0,0,128,128], retro: true),
				config:  File.read(conf)
			}
		end
	end

	return ret
end

$sections = load_sections $dir[:sections]


class Game < Gosu::Window
	def initialize
		#@sections = [
		#	Section.new(data: $sections[:placeholder_one], index: 0),
		#	Section.new(data: $sections[:placeholder_two], index: 1)
		#]

		@sections = gen_sections $sections

		@bg_color = Gosu::Color.argb 0xff_ffffff

		super $screen[:w], $screen[:h]
		self.caption = "Mother Nature"
	end

	def gen_sections sections
		sects = sections.shuffle
		sects.each do |section|
		end
	end

	def button_down id
		close  if (id == Gosu::KB_Q)
	end

	def update
	end

	def draw
		# Draw background
		Gosu.draw_rect 0,0, $screen[:w],$screen[:h], @bg_color

		# Draw Sections
		@sections.each &:draw
	end
end

