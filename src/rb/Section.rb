
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

		# for debugging
		@font = Gosu::Font.new 24
		@debug_info = [ @biomes, @end_point_heights ]
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

	def draw
		# debug text
		@font.draw_rel @debug_info.to_s, ((@x - $camera.pos) + @size[:w] / 2), 32, 100, 0.5,0.5, 1,1, Gosu::Color.argb(0xff_000000)

		if (inverted?)
			@image.draw (@x + @size[:w] - $camera.pos), @y, 10, -4,4
		else
			@image.draw (@x - $camera.pos), @y, 10, 4,4
		end
	end
end

