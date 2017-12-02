
$section_index = 0

def load_sections directory
	ret = []

	dir_parent = Dir.new directory
	dir_parent.each do |parent|
		next  if (/\A\.{1,2}\z/ =~ parent)
		png = nil
		conf = nil
		if (Dir.exists? "#{directory}/#{parent}")
			dir = Dir.new("#{directory}/#{parent}")
		else
			next
		end
		dir.each do |file|
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

$sections = load_sections DIR[:sections]


class Game < Gosu::Window
	def initialize
		#@sections = [
		#	Section.new(data: $sections[0]),
		#	Section.new(data: $sections[1])
		#]

		@sections = gen_sections $sections

		@bg_color = Gosu::Color.argb 0xff_ffffff

		super Settings.screen[:w], Settings.screen[:h]
		self.caption = "Mother Nature"
	end

	def gen_sections sects
		ret = []
		sections = sects.shuffle
		sections.each_with_index do |section_data,index|
			break  if (ret.size >= Settings.sections[:count])
			section = Section.new data: section_data
			# TODO: Border sections

			if (index == 0 || index == sections.size - 1)
				found_border = false
				sections.each do |section_data_border|
					section_border = Section.new data: section_data_border
					if (section_border.is_border?)
						found_border = true
						ret << section_border
						$section_index += 1
						break
					end
				end
				next  if found_border
			end

			ret << section
			$section_index += 1

		end

		return ret
	end

	def button_down id
		close  if (id == Gosu::KB_Q)
	end

	def update
	end

	def draw
		# Draw background
		Gosu.draw_rect 0,0, Settings.map[:w],Settings.map[:h], @bg_color

		# Draw Sections
		@sections.each &:draw
	end
end

