
class Disaster
	def initialize args = {}
		@trigger = {
			x: -1,
			y: -1,
			w: 0,
			h: 0
		}

		@active = false

		init args
	end

	def init args = {}
	end

	def trigger!
	end

	def click ms
		if ( (ms[:x] > (@trigger[:x] - $camera.pos) && ms[:x] < (@trigger[:x] + @trigger[:w] - $camera.pos)) &&
				 (ms[:y] > @trigger[:y] && ms[:y] < (@trigger[:y] + @trigger[:h])) )
			trigger!
		end
	end

	def update
	end

	def draw
	end
end

