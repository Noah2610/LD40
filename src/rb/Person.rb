
class Person
	attr_reader :x,:y, :alive, :in_tornado, :in_earthquake
	attr_accessor :group_id
	def initialize args = {}
		$can_win_or_lose = true
		file = get_random_file("#{DIR[:people]}", "png")
		@image = Gosu::Image.new file, retro: true
		@x = args[:x] || rand(Settings.sections[:size][:w] .. ($game.get_map_width - Settings.sections[:size][:w]))
		@y = args[:y] || Settings.screen[:h] - 64
		@direction = [
			{ x: -1, y: 0 },
			{ x: 1, y: 0 }
		].sample
		@pivoted = false
		@wobble_step = Settings.people[:move][:wobble][:step] * [1,-1].sample
		@group_id = args[:group_id] || nil
		@is_wandering = false
		@in_tornado = false
		@tornado_section = nil
		@falling = false
		@alive = true
		@in_earthquake = false

		if args[:initial_spawn]
			@falling = true
			@y = -10
		end


		# debugging
		@font = Gosu::Font.new 16
	end

	def is_falling?
		return @falling
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

	def find_base
		distance = group.base.x - @x
		@direction[:x] = distance.sign  unless (distance.nil?)
	end

	def new_base
		current_section = Section.find x: @x
		ids = []
		ids << current_section.id - 1  if (Section.exists?(current_section.id - 1, border: false))
		ids << current_section.id      if (Section.exists?(current_section.id, border: false))
		ids << current_section.id + 1  if (Section.exists?(current_section.id + 1, border: false))
		sections = Section.get_by_ids ids
		if (sections.any?)
			section = sections.sample
			$game.new_base group: group, section: section  if (section.bases.empty?)
		end
	end

	def get_section_distance_to_base
		current_section = Section.find x: @x
		base_section = Section.find x: group.base.x
		distance = base_section.section_index - current_section.section_index
		return distance
	end

	def wander
		unless (@is_wandering)
			@direction[:x] = [-1,1].sample
			return
		end

		@is_wandering = true

		distance = get_section_distance_to_base
		if (distance.abs >= Settings.people[:move][:wander_distance])
			@direction[:x] = distance.sign
		end
	end

	def move
		# Turn around if person is on border_section
		if (!@pivoted && ((Section.find(borders: true).map { |s| s.is_inside? x: @x }).include? true))
			@direction[:x] *= -1
			@pivoted = true
		elsif (!(Section.find(borders: true).map { |s| s.is_inside? x: @x }).include? true)
			@pivoted = false  if @pivoted
		end
		@x += Settings.people[:move][:step][:x] * @direction[:x]
		@y += Settings.people[:move][:step][:y] * @direction[:y]
	end

	def move_tornado
		@y -= Settings.people[:move][:tornado_step]  unless (@y < (Settings.sections[:size][:h].to_f * 0.5))
		@x += Settings.people[:move][:tornado_step] * @direction[:x]
	end

	def tornado!
		@in_tornado = true
		@tornado_section = Section.find x: @x
	end

	def no_tornado!
		return  unless (@in_tornado)
		@falling = true
	end

	def earthquake!
		@in_earthquake = true
	end

	def no_earthquake!
		@in_earthquake = false
		@wobble_step = Settings.people[:move][:wobble][:step] * [1,-1].sample
	end

	def fall
		@y += Settings.people[:move][:fall_step]
		if (@y > ((Settings.screen[:h] - Settings.sections[:size][:h]) + (Settings.sections[:size][:h].to_f * 0.875)))
			@falling = false
			if (@in_tornado)
				@in_tornado = false
				die!
			end
		end
	end

	def die!
		# Play wilhelm scream
		$game.samples[:wilhelm_scream].play(
			rand(Settings.people[:scream][:vol_range]), rand(Settings.people[:scream][:speed_range])
		)  if (rand(0.0 .. 1.0) < Settings.people[:scream][:chance])
		$deaths += 1
		@alive = false
		# Grave texture
		@image = $game.misc[:rip]
	end

	def update
		return   unless (@alive)

		if (@falling)
			fall  if ($update_counter % Settings.people[:move][:fall_interval] == 0)
			return
		end

		if (@in_tornado || @in_earthquake)
			if (@in_earthquake)
				if ($update_counter % Settings.disasters[:earthquake][:interval] == 0)
					@wobble_step = Settings.disasters[:earthquake][:shake].to_f * 1.5  unless (@wobble_step.abs == (Settings.disasters[:earthquake][:shake].to_f * 1.5))
					@wobble_step *= -1
					chance = Settings.disasters[:earthquake][:die_chance] * 100.0
					die!  if (rand(0 .. 100) < chance)
				end

			elsif (@in_tornado)
				@direction[:x] = [-1,1].sample           if (@direction[:x] == 0)
				section = Section.find x: @x
				move_tornado                             if ($update_counter % Settings.people[:move][:tornado_interval] == 0)
				if (section != @tornado_section)
					@direction[:x] = (@tornado_section.section_index - section.section_index).sign
				end

			end

			return
		end

		if ($update_counter % Settings.people[:move][:find_interval] == 0)

			if (group.nil?)
				# NOT IN GROUP
				find_closest_person

			elsif (!group.nil? && !is_leader? && !group.has_base?)
				# IN GROUP - NOT LEADER - NO BASE
				find_group_leader

			elsif (!group.nil? && !is_leader? && group.has_base?)
				# IN GROUP - NOT LEADER - HAS BASE
				wander

			elsif (!group.nil? && is_leader? && !group.has_base?)
				# IN GROUP - IS LEADER - NO BASE
				if (group.get_people.size >= Settings.evolution[:init_base_at])
					new_base
				end

			elsif (!group.nil? && is_leader? && group.has_base?)
				# IN GROUP - IS LEADER - HAS BASE
				if (group.get_people.size >= Settings.evolution[:new_base_interval])
					new_base
				end
			end

			find_next_path_point
		end

		move                if ($update_counter % Settings.people[:move][:interval] == 0)
		@wobble_step *= -1  if ($update_counter % Settings.people[:move][:wobble][:interval] == 0)
	end

	def draw
		# DEVELOPMENT
		if (is_leader?)
			@font.draw "LEADER", (@x - $camera.pos), @y - 150, 500, 1,1, Gosu::Color.argb(0xff_ff0000)
		end
		unless (group.nil?)
			@font.draw group.group_id.to_s, (@x - $camera.pos), @y - 100, 500, 1,1, Gosu::Color.argb(0xff_ff0000)
		end


		if (@alive)
			scale_x = Settings.people[:size][:w].to_f / Settings.people[:image_size][:w].to_f
			scale_y = Settings.people[:size][:h].to_f / Settings.people[:image_size][:h].to_f
			@image.draw (@x - $camera.pos), (@y + @wobble_step), 200, scale_x, scale_y
		elsif (!@alive)
			scale_x = Settings.people[:rip_size][:w].to_f / Settings.people[:rip_image_size][:w].to_f
			scale_y = Settings.people[:rip_size][:h].to_f / Settings.people[:rip_image_size][:h].to_f
			@image.draw (@x - $camera.pos), @y, 175, scale_x, scale_y
		end
	end
end

