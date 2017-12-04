
class Section
	attr_reader :x,:y, :image, :biomes, :end_point_heights, :build_levels, :section_index
	def initialize args = {}
		@size = Settings.sections[:size]
		#@section_index = $section_index
		#@x = args[:x] || @section_index * @size[:w]
		#@y = args[:y] || Settings.screen[:h] - @size[:h]
		@x = 0
		@y = Settings.screen[:h] - @size[:h]
		@inverted = false
		@builds = []
		@image = args[:data][:image]
		@shake = 0

		eval(args[:data][:config])

		# Adjust build_level point positions
		adjust_build_levels
		adjust_end_point_heights
		adjust_people_path_points

		@disaster = :nil  unless (defined? @disaster)

		# for debugging
		@font = Gosu::Font.new 16
	end

	def init
		index = 0
		@section_index = $section_index.dup
		@x = @size[:w] * @section_index
		$section_index += 1

		return self
	end

	def self.exists? id, opts
		section = self.get_by_ids([id])[0]
		case opts[:border]
		when nil
			ret = !!section
		when false
			if (!!section)
				ret = !section.is_border?
			end
		when true
			if (!!section)
				ret = section.is_border?
			end
		end

		if (ret)
			if (opts[:only_base])
				bases.each do |b|
					ret = false  if (b != opts[:only_base])
				end
			end
		end

		return ret
	end

	def self.find args
		ret = nil
		unless (args[:border] || args[:borders])
			$game.sections.each do |section|
				if (section.is_inside? x: args[:x])
					ret = section
					break
				end
			end
		else
			ret = []
			$game.sections.each do |section|
				if (section.is_border?)
					ret << section
				end
			end
		end
		return ret
	end

	def self.get_by_ids ids
		ret = []
		$game.sections.each do |section|
			if (ids.include? section.id)
				ret << section
			end
		end
		return ret
	end

	def id
		return @section_index
	end

	def bases
		ret = []
		$game.bases.each do |b|
			if (b.section == self)
				ret << b
			end
		end
		return ret
	end

	def is_inside? pos
		return (pos[:x] >= @x &&
						pos[:x] < @x + @size[:w])
	end

	def get_closest_path_point args
		args[:x] = args[:x].dup
		args[:x] -= @x
		ret = nil
		people_path_points = [].concat(@people_path_points).concat(@build_levels)
		people_path_points.insert 0, { x: 0, y: @end_point_heights[:left] }
		people_path_points << { x: @size[:w], y: @end_point_heights[:right] }
		people_path_points = (args[:dir] == 1 ? people_path_points : (args[:dir] == -1 ? people_path_points.reverse : nil))
		people_path_points.each do |point|
			# Skip point if position is already past it
			next  if ( (args[:dir] == 1 && args[:x] >= point[:x]) ||
								 (args[:dir] == -1 && args[:x] <= point[:x]) )
			ret = point
			break
		end  unless (people_path_points.nil?)
		return ret
	end

	def get_biome side
		case side
		when :left
			return @biomes[0]
		when :right
			if (@biomes.size == 2)
				return @biomes[1]
			else
				return @biomes[0]
			end
		end
	end

	def can_have_neighbor? section_right
		return (
			@end_point_heights[:right] == section_right.end_point_heights[:left]
		)
		return (
			( @end_point_heights[:right] == section_right.end_point_heights[:left] ) &&
			( get_biome(:right) == section_right.get_biome(:left) )
		)
	end

	def is_border?
		return @border
	end

	def to_border!
		@border = true
	end

	def inverted?
		return @inverted
	end

	def invert!
		tmp = @end_point_heights[:left].dup
		@end_point_heights[:left] = @end_point_heights[:right].dup
		@end_point_heights[:right] = tmp
		@inverted = true
	end

	def adjust_build_levels
		@build_levels.each do |point|
			point[:x] *= (Settings.sections[:size][:w] / Settings.sections[:image_size][:w])
			point[:y] *= (Settings.sections[:size][:h] / Settings.sections[:image_size][:h])
			point[:y] += @y
		end
	end

	def adjust_end_point_heights
		[:left,:right].each do |side|
			@end_point_heights[side] *= (Settings.sections[:size][:h] / Settings.sections[:image_size][:h])
			@end_point_heights[side] += @y
		end
	end

	def adjust_people_path_points
		@people_path_points.each do |point|
			point[:x] *= (Settings.sections[:size][:w] / Settings.sections[:image_size][:w])
			point[:y] *= (Settings.sections[:size][:h] / Settings.sections[:image_size][:h])
			point[:y] += @y
		end
	end

	def has_tornado!
		$game.people.each do |person|
			if (is_inside? x: person.x)
				person.tornado!  unless (person.in_tornado)
			end
		end
	end

	def has_no_tornado!
		$game.people.each do |person|
			if (is_inside? x: person.x)
				person.no_tornado!  if (person.in_tornado)
			end
		end
	end

	def has_earthquake!
		@shake = Settings.disasters[:earthquake][:shake]
		$game.people.each do |person|
			if (is_inside? x: person.x)
				person.earthquake!  unless (person.in_earthquake)
			end
		end
		bases.each do |base|
			base.shake = @shake
		end
	end

	def has_no_earthquake!
		@shake = 0
		$game.people.each do |person|
			if (is_inside? x: person.x)
				person.no_earthquake!  if (person.in_earthquake)
			end
		end
		bases.each do |base|
			base.shake = 0
		end
	end

	def update
		if (@shake != 0)
			if ($update_counter % Settings.disasters[:earthquake][:shake_interval] == 0)
				@shake *= -1
				bases.each do |base|
					base.shake *= -1
					chance = Settings.disasters[:earthquake][:die_chance] * 1.5 * 100.0
					base.destroy!  if (rand(0 .. 100) < chance)
				end
			end

		end
	end

	def draw
		# DEVELOPMENT
		# debug text
		@debug_info = [ @biomes, @end_point_heights, @inverted, is_border?]
		@font.draw_rel @debug_info.to_s, ((@x - $camera.pos) + @size[:w] / 2), 32, 100, 0.5,0.5, 1,1, Gosu::Color.argb(0xff_000000)
		# build level points
		@build_levels.each do |point|
			Gosu.draw_rect (@x + point[:x] - $camera.pos), (point[:y]), 8,8, Gosu::Color.argb(0xff_ff0000), 500
		end
		# people_path_points
		@people_path_points.each do |point|
			Gosu.draw_rect (@x + point[:x] - $camera.pos), (point[:y]), 8,8, Gosu::Color.argb(0xff_0000ff), 500
		end
		# end_points
		Gosu.draw_rect (@x - $camera.pos), (@end_point_heights[:left]), 8,8, Gosu::Color.argb(0xff_00ff00), 500
		Gosu.draw_rect (@x + @size[:w] - $camera.pos), (@end_point_heights[:right]), 8,8, Gosu::Color.argb(0xff_00ff00), 500


		scale = Settings.sections[:size][:w].to_f / Settings.sections[:image_size][:w].to_f
		if (inverted?)
			@image.draw (@x + @size[:w] - $camera.pos), (@y + @shake), 10, -scale,scale
		else
			@image.draw (@x - $camera.pos), (@y + @shake), 10, scale,scale
		end
	end
end

