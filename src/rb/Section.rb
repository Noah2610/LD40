
class Section
	def initialize args = {}
		@size = Settings.sections[:size]
		@section_index = args[:index] || 0
		@x = args[:x] || @section_index * @size[:w]
		@y = args[:y] || $screen[:h] - @size[:h]
		@image = args[:data][:image]
		eval(args[:data][:config])
	end

	def draw
		@image.draw @x,@y, 10, 4,4
	end
end

