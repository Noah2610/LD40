
class Base
	attr_reader :x,:y, :section, :group
	def initialize args
		@group = args[:group]
		@section = args[:section]
		@build_level_index = args[:build_level_index]
		@x = @section.x + build_level[:x]
		@y = build_level[:y]
	end

	def build_level
		return @section.build_levels[@build_level_index]
	end

	def draw
		Gosu.draw_rect (@x - $camera.pos), @y, 100,100, Gosu::Color.argb(0xff_00ff00), 50
	end
end

