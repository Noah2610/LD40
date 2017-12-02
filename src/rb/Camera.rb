
class Camera
	attr_reader :pos
	def initialize args
		@pos = 0.0
		@step = 16
		@sections = args[:sections]
	end

	# Left border, right border, or center of camera view
	def get_part_pos side
		case side
		when :left
			return @pos
		when :right
			return @pos + Settings.screen[:w].to_f
		when :center
			return @pos + (Settings.screen[:w].to_f / 2.0)
		end
	end

	def get_pos_in_percent part = :left
		return (get_part_pos(part).to_f / (@sections.size * Settings.sections[:size][:w]).to_f) * 100.0
	end

	def move direction
		case direction
		when :left
			@pos -= @step  unless (@pos <= 0)
		when :right
			@pos += @step  unless (get_part_pos(:right) >= $game.get_map_width)
		end
	end
end

