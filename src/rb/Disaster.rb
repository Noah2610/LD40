
class Disaster
	def initialize args = {}
		@trigger = {
			x: -1,
			y: -1,
			w: 0,
			h: 0
		}

		init args
	end

	def init args = {}
	end

	def trigger!
	end

	def click ms
		if ( (ms[:x] > @trigger[:x] && ms[:x] < (@trigger[:x] + @trigger[:w])) &&
				 (ms[:y] > @trigger[:y] && ms[:y] < (@trigger[:y] + @trigger[:h])) )
			trigger!
		end
	end

	def update
	end

	def draw
	end
end

