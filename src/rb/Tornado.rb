
class Tornado < Disaster
	def init args
		@trigger = {
			x: (Settings.screen[:w] - Settings.disasters[:tornado][:display][:size][:w]),
			y: 0,
			w: Settings.disasters[:tornado][:display][:size][:w],
			h: Settings.disasters[:tornado][:display][:size][:h]
		}

		@display = {
			images: [
				Gosu::Image.new("#{DIR[:disasters]}/tornado/display_zero.png"),
				Gosu::Image.new("#{DIR[:disasters]}/tornado/display_one.png"),
				Gosu::Image.new("#{DIR[:disasters]}/tornado/display_two.png"),
				Gosu::Image.new("#{DIR[:disasters]}/tornado/display_three.png")
			],
			current: 1,
			x: @trigger[:x],
			y: @trigger[:y]
		}

		@effect = {
			images: [
				Gosu::Image.new("#{DIR[:disasters]}/tornado/effect_one.png"),
				Gosu::Image.new("#{DIR[:disasters]}/tornado/effect_two.png"),
				Gosu::Image.new("#{DIR[:disasters]}/tornado/effect_three.png")
			],
			current: 0
		}

		@active = false
		@activated_at = nil
		@deactivated_at = nil
		@strength = nil
		@sections = []
	end

	def next_image target
		case target
		when :display
			chance = Settings.disasters[:tornado][:wind_chance] * 100.0
			if (rand(0 .. 100) < chance)
				@display[:current] += 1  unless (@display[:current] >= @display[:images].size - 1)
			end
		when :effect
			unless (@effect[:current] >= @effect[:images].size - 1)
				@effect[:current] += 1
			else
				@effect[:current] = 0
			end
		end
	end

	def trigger!
		return    if (@active)
		activate  if (@display[:current] > 0)
	end

	def activate
		@active = true
		@activated_at = Time.now
		@strength = @display[:current]

		case @strength
		when 1
			@sections = [
				Section.find(x: $camera.get_part_pos(:center))
			]
		when 2
			@sections = [
				Section.find(x: $camera.get_part_pos(:center)),
				Section.find(x: ($camera.get_part_pos(:center) + ((rand(2) == 0) ? Settings.sections[:size][:w] : -Settings.sections[:size][:w])))
			]
		when 3
			@sections = [
				Section.find(x: $camera.get_part_pos(:center)),
				Section.find(x: ($camera.get_part_pos(:center) + Settings.sections[:size][:w])),
				Section.find(x: ($camera.get_part_pos(:center) - Settings.sections[:size][:w]))
			]
		end

		@sections.each &:has_tornado!

		@display[:current] = 0
	end

	def deactivate
		@sections.each &:has_no_tornado!
		@active = false
		@activated_at = nil
		@deactivated_at = Time.now
		@strength = nil
		@sections = []
	end

	def update
		next_image :display               if (!@active && $update_counter % Settings.disasters[:tornado][:wind_interval] == 0)

		@sections.each &:has_tornado!     if (@active && ($update_counter % Settings.disasters[:tornado][:update] == 0))

		@sections.each &:has_no_tornado!  if (!@active && !@deactivated_at.nil? && (Time.now > (@deactivated_at + 1)))

		deactivate                        if (@active && Time.now > (@activated_at + Settings.disasters[:tornado][:active_time]))
	end

	def draw
		# Draw display
		scale_x = Settings.disasters[:tornado][:display][:size][:w].to_f / Settings.disasters[:tornado][:display][:image_size][:w].to_f
		scale_y = Settings.disasters[:tornado][:display][:size][:h].to_f / Settings.disasters[:tornado][:display][:image_size][:h].to_f
		@display[:images][@display[:current]].draw @display[:x], @display[:y], 20, scale_x, scale_y

		# Draw effect
		if (@active)
			scale_x = Settings.sections[:size][:w].to_f / Settings.sections[:image_size][:w].to_f
			scale_y = Settings.sections[:size][:h].to_f / Settings.sections[:image_size][:h].to_f
			@sections.each do |section|
				@effect[:images][@effect[:current]].draw (section.x - $camera.pos), section.y, 250, scale_x, scale_y
			end
			next_image :effect  if ($update_counter % (Settings.disasters[:tornado][:effect_interval].to_f / @strength.to_f).round == 0)
		end

	end
end

