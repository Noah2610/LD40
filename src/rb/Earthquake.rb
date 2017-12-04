
class Earthquake < Disaster
	def init args = {}
		@section = args[:section]
		@trigger = {
			x: @section.x,
			y: (Settings.screen[:h] - Settings.disasters[:earthquake][:h]),
			w: Settings.sections[:size][:w],
			h: Settings.disasters[:earthquake][:h]
		}
		@trigger_color = Gosu::Color.argb 0xff_cccccc
		@activated_at = 0
		@timeout = Time.now
	end

	def trigger!
		activate  unless (Time.now < @timeout)
	end

	def activate
		deactivate
		@active = true
		@activated_at = Time.now
		@section.has_earthquake!
		@timeout = Time.now + Settings.disasters[:earthquake][:active_time] + Settings.disasters[:earthquake][:timeout]
	end

	def deactivate
		@active = false
		@activated_at = 0
		@section.has_no_earthquake!
	end

	def update
		@section.has_earthquake!  if (@active && $update_counter % Settings.disasters[:update] == 0)
		deactivate                if (@active && $update_counter % Settings.disasters[:update] == 0 && Time.now > (@activated_at + Settings.disasters[:earthquake][:active_time]))
	end

	def draw
		# Draw eathquake trigger section
		if (Time.now > @timeout)
			Gosu.draw_rect (@trigger[:x] - $camera.pos), @trigger[:y], @trigger[:w], @trigger[:h], @trigger_color, 20
		end
	end
end

