
class Settings
	def self.screen
		return {
			w: 860,
			h: 640
		}
	end

	def self.map
		return {
			w: 4000,
			h: self.screen[:h]
		}
	end

	def self.sections
		return {
			size: { w: 512, h: 512 },
			count: 2
		}
	end

end
