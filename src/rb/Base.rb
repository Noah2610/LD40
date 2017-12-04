
class Base
	attr_reader :x,:y, :section, :group
	def initialize args
		@group = args[:group]
		@section = args[:section]
		@build_level_index = args[:build_level_index]
		@x = @section.x + build_level[:x]
		@y = build_level[:y]
		file = get_random_file("#{DIR[:buildings]}", "png")
		@image = Gosu::Image.new file, retro: true
		@type = file.split("/")[-1].gsub(".png", "").to_sym
	end

	def build_level
		return @section.build_levels[@build_level_index]
	end

	def draw
		scale_x = Settings.builds[:size][:w].to_f / Settings.builds[:image_size][:w].to_f
		scale_y = Settings.builds[:size][:h].to_f / Settings.builds[:image_size][:h].to_f
		@image.draw (@x - (@image.width / 2) - $camera.pos), (@y - @image.height), 150, scale_x, scale_y
	end
end

