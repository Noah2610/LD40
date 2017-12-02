
class Section
	attr_reader :biome
	def initialize args = {}
		@size = Settings.sections[:size]
		@section_index = $section_index
		@x = args[:x] || @section_index * @size[:w]
		@y = args[:y] || Settings.screen[:h] - @size[:h]
		@image = args[:data][:image]
		@inverted = false
		eval(args[:data][:config])
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
		if (inverted?)
			@image.draw (@x + @size[:w] - $camera.pos), @y, 10, -4,4
		else
			@image.draw (@x - $camera.pos),@y, 10, 4,4
		end
	end
end

