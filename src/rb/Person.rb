
class Person
	attr_reader :x,:y
	def initialize args = {}
		@image = Gosu::Image.new "#{DIR[:people]}/placeholder.png", retro: true
		@x = args[:x] || rand(Settings.sections[:size][:w] .. ($game.get_map_width - Settings.sections[:size][:w]))
		@y = args[:y] || Settings.screen[:h] - 64
		@update_counter = 0
		@direction = [
			{ x: -1, y: 0 },
			{ x: 1, y: 0 }
		].sample
	end

	def find_closest_person
		# "Pathfind" to closest person
		distance = Settings.people[:move][:min_distance]
		dir_y = nil
		$game.people.each do |person|
			next  if person == self
			dist = person.x - @x
			if (dist.abs < distance.abs)
				distance = dist
				dir_y = (person.y - @y).sign
			end
		end

		unless (distance.nil?)
			@direction[:x] = distance.sign
			@direction[:y] = dir_y  unless dir_y.nil?
			puts @direction.to_s
		end
	end

	def move

		@x += Settings.people[:move][:step][:x] * @direction[:x]
		@x += Settings.people[:move][:step][:y] * @direction[:y]
	end

	def update
		move                 if (@update_counter % Settings.people[:move][:interval] == 0)
		find_closest_person  if (@update_counter % Settings.people[:move][:find_interval] == 0)
		@update_counter += 1
	end

	def draw
		@image.draw (@x - $camera.pos),@y, 200, 4,4
	end
end

