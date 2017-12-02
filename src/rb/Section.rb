
class Section
	attr_reader :biome
	def initialize args = {}
		@size = Settings.sections[:size]
		@section_index = $section_index
		@x = args[:x] || @section_index * @size[:w]
		@y = args[:y] || Settings.screen[:h] - @size[:h]
		@image = args[:data][:image]
		eval(args[:data][:config])
	end

	def is_border?
		return !!@border
	end

	def border_side
		return @border
	end

	def inverted?
		return true   if (@border == :right)
		return false  if (@border == :left || @border == false)
	end

	def draw
		if (inverted?)
			@image.draw (@x + @size[:w]), @y, 10, -4,4
		else
			@image.draw @x,@y, 10, 4,4
		end
	end
end

