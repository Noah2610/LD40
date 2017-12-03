
$section_index = 0

class ::Integer
	def sign
		return self  if self == 0
		return self / self.abs
	end
end
class ::Float
	def sign
		return self  if self == 0.0
		return self / self.abs
	end
end

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

		# add section data if .png and .conf.rb are present
		if (File.exists?(png) && File.exists?(conf))
			size = [Settings.sections[:image_size][:w], Settings.sections[:image_size][:w]]
			ret << {
				name:    parent.to_sym,
				image:   Gosu::Image.new(png, rect: [0,0,size[0],size[1]], retro: true),
				config:  File.read(conf)
			}
		end
	end

	return ret
end

$sections = load_sections DIR[:sections]


class Game < Gosu::Window
	attr_reader :people
	def initialize
		#@sections = [
		#	Section.new(data: $sections[0]),
		#	Section.new(data: $sections[1])
		#]

		@sections = gen_sections $sections

		$camera = Camera.new sections: @sections

		@minimap = MiniMap.new sections: @sections

		@year = Settings.year[:start]
		@year_last_time = Time.now
		@year_font = Gosu::Font.new 32

		@people = []

		@bg_color = Gosu::Color.argb 0xff_ffffff

		super Settings.screen[:w], Settings.screen[:h]
		self.caption = "Mother Nature"
	end

	def gen_sections sects
		puts "Generating map, this might take a moment (will stop generating after 5 seconds)"
		ret = []
		sections = sects.shuffle
		prev_section = nil
		gen_start = Time.now
		gen_timeout = 5

		# Add first border (left)
		sections.each do |section_data|
			if (Time.now > gen_start + gen_timeout)
				puts "SECTION GENERATION TIMEOUT, longer than 5 seconds"
				break
			end
			section = Section.new data: section_data
			if (section.is_border?)
				ret << section
				prev_section = section
				$section_index += 1
				break
			end
		end

		# Add middle sections
		#sections.each_with_index do |section_data,index|
		section_counter = 0
		while (ret.size < Settings.sections[:count] - 1)
			if (Time.now > gen_start + gen_timeout)
				puts "SECTION GENERATION TIMEOUT, longer than 5 seconds"
				break
			end
			#break  if (ret.size >= Settings.sections[:count] - 1)
			section = Section.new data: sections[section_counter]
			if (!section.is_border? && (prev_section.nil? || prev_section.can_have_neighbor?(section)))
				ret << section
				prev_section = section
				$section_index += 1
			end
			section_counter += 1
			section_counter = 0  if (section_counter >= sections.size)
		end

		# Add second border (right)
		sections.each do |section_data|
			if (Time.now > gen_start + gen_timeout)
				puts "SECTION GENERATION TIMEOUT, longer than 5 seconds"
				break
			end
			section = Section.new data: section_data
			if (section.is_border? && (prev_section.nil? || prev_section.can_have_neighbor?(section)))
				ret << section
				section.invert!
				$section_index += 1
				break
			end
		end

		return ret
	end

	def get_map_width
		return @sections.size * Settings.sections[:size][:w]
	end

	def button_down id
		close  if (id == Gosu::KB_Q)
	end

	def needs_cursor?
		true
	end

	def update
		# Move camera
		$camera.move :left   if (Controls.left?)
		$camera.move :right  if (Controls.right?)
		# Update MiniMap
		@minimap.update
		# Update year
		if (Time.now >= @year_last_time + Settings.year[:delay])
			@year += Settings.year[:step]
			@year_last_time = Time.now
			@people << Person.new  if (Settings.people[:initial_spawns_at].include? @year)
		end
		# Update people
		@people.each &:update
	end

	def draw
		# Draw background
		Gosu.draw_rect 0,0, Settings.map[:w],Settings.map[:h], @bg_color, 0

		# Draw Sections
		@sections.each &:draw

		# Draw MiniMap
		@minimap.draw

		# Draw current year
		year_pos = Settings.year[:display][:pos]
		@year_font.draw "Year", year_pos[:x], year_pos[:y] - 32, 300, 1,1, Settings.year[:display][:color]
		@year_font.draw "#{@year}".rjust(4,"0"), year_pos[:x],year_pos[:y], 300, 1,1, Settings.year[:display][:color]

		# Draw people
		@people.each &:draw
	end
end

