
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
		@pivoted = false
	end

	def find_closest_person
		# "Pathfind" to closest person
		distance = nil #Settings.people[:move][:min_distance]
		#dir_y = nil
		$game.people.each do |person|
			next  if person == self
			dist = person.x - @x
			if (distance.nil? || dist.abs < distance.abs)
				distance = dist
				#dir_y = (person.y - @y).sign
			end
		end

		unless (distance.nil?)
			@direction[:x] = distance.sign
			#@direction[:y] = dir_y  unless dir_y.nil?
		end
	end

	### TODO:
	### Don't use build_levels for person paths, use seperate more points (in section config)
	def find_next_path_point
		current_section = Section.find x: @x

		unless (current_section.nil?)
			next_point = current_section.get_closest_path_point x: @x, y: @y, dir: @direction[:x]
			@direction[:y] = (next_point[:y] - @y).sign  unless (next_point.nil?)
		end
	end

	def move
		# Turn around if person is on border_section
		if (((Section.find(borders: true).map { |s| s.is_inside? x: @x }).include? true) && !@pivoted)
			@direction[:x] *= -1
			@pivoted = true
		else
			@pivoted = false  if @pivoted
		end
		@x += Settings.people[:move][:step][:x] * @direction[:x]
		@y += Settings.people[:move][:step][:y] * @direction[:y]
	end

	def update
		if (@update_counter % Settings.people[:move][:find_interval] == 0)
			find_closest_person
			find_next_path_point
		end
		move                 if (@update_counter % Settings.people[:move][:interval] == 0)
		@update_counter += 1
	end

	def draw
		@image.draw (@x - $camera.pos),@y, 200, 4,4
	end
end

