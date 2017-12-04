
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
			count: 8
		}
	end

	def self.year
		return {
			start:            0,
			step:             10,
			delay:            1,
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
			initial_spawns_at: [10,20,30,40, 80, 120, 160, 200, 300, 400, 500, 600],
			#initial_spawns_at: [50, 100],
			size:              { w: 8, h: 12 },
			image_size:        { w: 8, h: 12 },
			move: {
				interval:             10,
				tornado_interval:     1,
				tornado_step:         10,
				fall_interval:        1,
				fall_step:            10,
				find_interval:        100,
				min_distance:         2048,
				step: {
					x: 6,
					y: 2
				},
				wobble: {
					step:     2,
					interval: 10
				},
				wander_distance: 2  # in sections
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
			size:         { w: 64, h: 128 },
			image_size:   { w: 32, h: 64  },
			update:       50,
			baby_chance:  (1.0 / 10.0),
			types: {
				wood: {

				},
				stone: {

				}
			}
		}
	end

	def self.disasters
		return {
			update:     50,

			tornado: {
				display: {
					size:       { w: 128, h: 64 },
					image_size: { w: 64, h: 64 }
				},
				wind_interval:    100,
				wind_chance:      (1.0 / 10.0),
				active_time:      5,
				effect_interval:  10,
			},

			earthquake: {
				h:                24,
				shake:            8,
				shake_interval:   6,
				active_time:      5,
				interval:         10,
				die_chance:       (1.0 / 100.0),
				timeout:          10
			}
		}
	end

end
