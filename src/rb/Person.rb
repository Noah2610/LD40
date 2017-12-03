
class Person
	attr_reader :x,:y
	attr_accessor :group_id
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
		@wobble_step = Settings.people[:move][:wobble][:step] * [1,-1].sample
		@group_id = nil

		# debugging
		@font = Gosu::Font.new 16
	end

	def group
		$game.groups.each do |group|
			if (group.has_person? self)
				return group
			end
		end
		return nil
	end

	def is_leader?
		return nil  if (group.nil?)
		return group.leader == self
	end

	def get_closest_person
		closest = nil
		distance = nil
		$game.people.each do |person|
			next  if (person == self)
			dist = person.x - @x
			if (distance.nil? || dist.abs < distance.abs)
				distance = dist
				closest = person
			end
		end
		return { person: closest, distance: distance }
	end

	def find_closest_person
		# "Pathfind" to closest person
		#distance = nil #Settings.people[:move][:min_distance]
		closest = get_closest_person
		@direction[:x] = closest[:distance].sign  unless (closest[:distance].nil?)
	end

	def find_group_leader
		return  if (group.nil? || group.leader == self)
		# "Pathfind" to group leader
		unless (group.leader.nil?)
			distance = group.leader.x - @x
			@direction[:x] = distance.sign  unless distance.nil?
		end
	end

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
			if (group.nil?)
				find_closest_person
			elsif (!group.nil?)
				find_group_leader
			end
			find_next_path_point
		end
		move                if (@update_counter % Settings.people[:move][:interval] == 0)
		@wobble_step *= -1  if (@update_counter % Settings.people[:move][:wobble][:interval] == 0)

		@update_counter += 1
	end

	def draw
		# DEVELOPMENT
		if (is_leader?)
			@font.draw "LEADER", (@x - $camera.pos), @y - 150, 500, 1,1, Gosu::Color.argb(0xff_ff0000)
		end
		unless (group.nil?)
			@font.draw group.group_id.to_s, (@x - $camera.pos), @y - 100, 500, 1,1, Gosu::Color.argb(0xff_ff0000)
		end


		@image.draw (@x - $camera.pos), (@y + @wobble_step), 200, 4,4
	end
end

