
class Game < Gosu::Window
	def initialize
		super $screen[:w], $screen[:h]
		self.caption = "Mother Nature"
	end

	def button_down id
		close  if (id == Gosu::KB_Q)
	end

	def update
	end

	def draw
	end
end

