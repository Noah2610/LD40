
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
			count: 32
		}
	end

	def self.year
		return {
			start:            0,
			step:             50,
			delay:            2,
			day_night_switch: 100,
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
			#initial_spawns_at: [50, 100],
			move: {
				interval:      30,
				find_interval: 100,
				min_distance:  2048,
				step: {
					x: 8,
					y: 2
				},
				wobble: {
					step:     2,
					interval: 30
				}
			},
			display: {
				pos: {
					x: (self.screen[:w] - 128),
					y: 192,
				},
				color: Gosu::Color.argb(0xcc_0000ff)
			}
		}
	end

	def self.evolution
		return {
			handle_interval: 50,
			baby_interval:   50,
			baby_chance:     (1.0 / 10.0),
			baby_distance:   64,
			group_distance:  128,
			init_base_at:    4   # people
		}
	end

	def self.builds
		return {

		}
	end

end
