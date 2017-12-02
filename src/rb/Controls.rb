
class Controls
	@@left = [
		Gosu::KB_A,
		Gosu::KB_LEFT,
		Gosu::KB_H
	]
	@@right = [
		Gosu::KB_D,
		Gosu::KB_L,
		Gosu::KB_RIGHT
	]

	def self.left?
		@@left.each do |key|
			return true  if (Gosu.button_down? key)
		end
		return false
	end
	def self.right?
		@@right.each do |key|
			return true  if (Gosu.button_down? key)
		end
		return false
	end
end

