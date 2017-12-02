
class Camera
	attr_reader :pos
	def initialize
		@pos = 0
		@step = 16
	end

	def move direction
		case direction
		when :left
			@pos -= @step  unless (@pos <= 0)
		when :right
			@pos += @step  unless (@pos >= Settings.screen[:w])
		end
	end
end

