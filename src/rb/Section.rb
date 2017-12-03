
class Section
	attr_reader :x,:y, :image, :biomes, :end_point_heights
	def initialize args = {}
		@size = Settings.sections[:size]
		@section_index = $section_index
		@x = args[:x] || @section_index * @size[:w]
		@y = args[:y] || Settings.screen[:h] - @size[:h]
		@inverted = false
		@image = args[:data][:image]
		eval(args[:data][:config])

		# Adjust build_level point positions
		adjust_build_levels
		adjust_end_point_heights
		adjust_people_path_points

		# for debugging
		@font = Gosu::Font.new 24
		@debug_info = [ @biomes, @end_point_heights ]
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

	def is_inside? pos
		return (pos[:x] >= @x &&
						pos[:x] < @x + @size[:w])
	end

	def get_closest_path_point args
		args[:x] = args[:x].dup
		args[:x] -= @x
		ret = nil
		people_path_points = @people_path_points
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
			( @end_point_heights[:right] == section_right.end_point_heights[:left] ) &&
			( get_biome(:right) == section_right.get_biome(:left) )
		)
	end

	def is_border?
		return @border
	end

	def inverted?
		return @inverted
	end

	def invert!
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

	def draw
		# DEVELOPMENT
		# debug text
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
			@image.draw (@x + @size[:w] - $camera.pos), @y, 10, -scale,scale
		else
			@image.draw (@x - $camera.pos), @y, 10, scale,scale
		end
	end
end

