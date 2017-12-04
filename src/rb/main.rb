
$section_index = 0
$group_ids = 0
$update_counter = 0

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
	datas = []

	dir_parent = Dir.new directory
	dir_parent.each do |parent|
		next  if (parent == "." || parent == "..")
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
			data = {
				name:    parent,
				image:   Gosu::Image.new(png, rect: [0,0,size[0],size[1]], retro: true),
				config:  File.read(conf)
			}
			datas << data
		end
	end

	ret = []
	datas.each do |data|
		section = Section.new data: data
		ret << section
		if (!section.is_border?)
			section2 = Section.new data: data
			section2.invert!
			ret << section2
		end
	end
	return ret
end


def get_random_file directory, extension = "png"
	files = []
	dir = Dir.new(directory)
	dir.each do |file|
		next                             if (Dir.exists? file)
		files << "#{directory}/#{file}"  if (/\A.+\.#{extension}\z/ =~ file)
	end
	return files.sample
end


class Game < Gosu::Window
	attr_reader :sections, :people, :groups, :bases
	def initialize
		@sections = gen_sections load_sections(DIR[:sections])

		$camera = Camera.new sections: @sections

		@minimap = MiniMap.new sections: @sections

		@year = Settings.year[:start]
		@year_last_time = Time.now
		@year_font = Gosu::Font.new 32

		@people_font = Gosu::Font.new 32

		@people = []
		@groups = []
		@bases = []

		@disasters = [Tornado.new]

		@sections.each do |section|  # Add Earthquakes to each section except borders
			next  if (section.is_border?)
			@disasters << Earthquake.new(section: section)
		end

		@bg_color = Gosu::Color.argb(0xff_cccccc)

		super Settings.screen[:w], Settings.screen[:h]
		self.caption = "Mother Nature"
	end

	def gen_sections sects
		puts "Generating map, this might take a moment (will stop generating after 5 seconds)"
		ret = []
		sections = sects.shuffle
		prev_section = nil
		gen_start = Time.now
		#gen_timeout = 5
		gen_timeout = nil

		# Add first border (left)
		sections.each do |section|
			if (!gen_timeout.nil? && Time.now > gen_start + gen_timeout)
				puts "SECTION GENERATION TIMEOUT, longer than 5 seconds"
				break
			end
			if (section.is_border?)
				ret << section.init
				#section.set_index $section_index.dup
				prev_section = section
				break
			end
		end

		# Add middle sections
		section_counter = 0
		while (ret.size < Settings.sections[:count] - 1)
			if (!gen_timeout.nil? && Time.now > gen_start + gen_timeout)
				puts "SECTION GENERATION TIMEOUT, longer than 5 seconds"
				break
			end
			section = sections[section_counter].dup
			if (!section.is_border? && (prev_section.nil? || prev_section.can_have_neighbor?(section)))
				ret << section.init
				#section.set_index $section_index.dup
				prev_section = section
			end
			section_counter += 1
			section_counter = 0  if (section_counter >= sections.size)
		end

		# Add second border (right)
		sections.each do |section|
			if (!gen_timeout.nil? && Time.now > gen_start + gen_timeout)
				puts "SECTION GENERATION TIMEOUT, longer than 5 seconds"
				break
			end
			if (section.is_border? && (prev_section.nil? || prev_section.can_have_neighbor?(section)))
				ret << section.init
				section.invert!
				break
			end
		end

		# Check if first and last sections are borders.
		# If not, interpret them as such
		[0,(ret.size - 1)].each do |n|
			unless (ret[n].is_border?)
				ret[n].to_border!
			end
		end

		puts "DONE"
		return ret
	end

	def get_map_width
		return @sections.size * Settings.sections[:size][:w]
	end

	def get_people_groups args
		return []  if (@people.size < 2)
		distance = args[:distance]
		groups = []
		@people.each do |person|
			next  if (!person.alive || person.in_tornado)
			closest = person.get_closest_person
			next  if (closest.nil? || closest[:person].nil? || closest[:distance].nil?)
			if (closest[:distance].abs <= distance)
				unless (groups.map { |g| (g.include?(person) || g.include?(closest[:person]) ? true : false) }.include? true)
					groups << [person, closest[:person]]
				end
			end
		end
		return groups
	end

	def handle_new_person
		groups = get_people_groups distance: Settings.evolution[:baby_distance]

		groups.each do |group|
			chance = Settings.evolution[:baby_chance] * 100.0
			if (group[0].group == group[1].group && rand(0 .. 100) < chance)
				if (group[0].group.nil?)
					new_group = Group.new
					new_group.add_people group[0], group[1]
				end
				p = group.sample
				@people << Person.new(x: p.x, y: p.y)
			end
		end

	end

	def handle_people
		groups = get_people_groups distance: Settings.evolution[:group_distance]
		groups.each do |group|
			# Add people to group
			if (group[0].group.nil? && group[1].group.nil?)
				@groups << Group.new(people: [group[0], group[1]])
			elsif (!group[0].group.nil? && group[1].group.nil?)
				group[0].group.add_person group[1]
			elsif (group[0].group.nil? && !group[1].group.nil?)
				group[1].group.add_person group[0]
			end
		end

		handle_new_person
	end

	def new_base args
		build_level_index = rand(args[:section].build_levels.size)
		@bases << Base.new(group: args[:group], section: args[:section], build_level_index: build_level_index)
		args[:group].add_base @bases.last
	end

	def button_down id
		close  if (id == Gosu::KB_Q)
		if (id == Gosu::MS_LEFT)
			@disasters.each do |disaster|
				disaster.click x: mouse_x, y: mouse_y
			end
		end
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
			@people << Person.new(initial_spawn: true)   if (Settings.people[:initial_spawns_at].include? @year)
			#@people << Person.new   if (@year % 200 == 0)
			#@people << Person.new   if (@people.empty?)
		end

		# New person
		handle_people            if ($update_counter % Settings.evolution[:handle_interval] == 0)

		# Update sections (for disasters)
		@sections.each &:update

		# Update people
		@people.each &:update

		# Update disasters
		@disasters.each &:update

		$update_counter += 1
	end

	def draw
		# DEVELOPMENT
		# fps
		@year_font.draw "#{Gosu.fps}", 128,128, 400, 1,1, Gosu::Color.argb(0xff_000000)


		# Draw background
		Gosu.draw_rect 0,0, get_map_width,Settings.screen[:h], @bg_color, 0

		# Draw Sections
		@sections.each &:draw

		# Draw MiniMap
		@minimap.draw

		# Draw current year
		year_pos = Settings.year[:display][:pos]
		@year_font.draw "Year", year_pos[:x], year_pos[:y] - 32, 300, 1,1, Settings.year[:display][:color]
		@year_font.draw "#{@year}".rjust(4,"0"), year_pos[:x],year_pos[:y], 300, 1,1, Settings.year[:display][:color]

		# Draw people count
		people_pos = Settings.people[:display][:pos]
		count = 0
		@people.each do |person|
			count += 1  if (person.alive)
		end
		@people_font.draw "People", people_pos[:x], people_pos[:y] - 32, 300, 1,1, Settings.people[:display][:color]
		@people_font.draw "#{count}", people_pos[:x],people_pos[:y], 300, 1,1, Settings.people[:display][:color]

		# Draw people
		@people.each &:draw

		# Draw bases
		@bases.each &:draw

		# Draw disasters
		@disasters.each &:draw
	end
end


$camera = nil
$game = Game.new
$game.show

