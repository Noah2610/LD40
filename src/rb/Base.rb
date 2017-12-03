
class Base
	attr_reader :x,:y, :section, :group
	def initialize args
		@group = args[:group]
		@section = args[:section]
		@build_level_index = args[:build_level_index]
		@x = @section.x + build_level[:x]
		@y = build_level[:y]
		@image = Gosu::Image.new "#{DIR[:buildings]}/placeholder.png", retro: true
	end

	def build_level
		return @section.build_levels[@build_level_index]
	end

	def draw
		@image.draw (@x - (@image.width / 2) - $camera.pos), (@y - @image.height), 150, 1,1
	end
end

