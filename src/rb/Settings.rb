
class Settings
	def self.screen
		return {
			w: 1200,
			h: 640
		}
	end

	def self.map
		return {
			w: 8000,
			h: self.screen[:h]
		}
	end

	def self.sections
		return {
			size:       { w: 512, h: 512 },
			image_size: { w: 128, h: 128 },
			count: 14
		}
	end

	def self.year
		return {
			start: 0,
			step:  50,
			delay: 1,
			display: {
				pos: {
					x: (self.screen[:w] - 128),
					y: 128
				},
				color: Gosu::Color.argb(0xcc_0000ff)
			}
		}
	end

	def self.people
		return {
			initial_spawns_at: [50, 250,300,600,650],
			move: {
				interval:      10,
				find_interval: 200,
				min_distance:  2048,
				step: {
					x: 4,
					y: 4
				}
			},
		}
	end

end
