
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

end
