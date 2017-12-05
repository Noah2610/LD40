
class Earthquake < Disaster
	def init args = {}
		@section = args[:section]
		@trigger = {
			x: @section.x,
			y: (Settings.screen[:h] - Settings.disasters[:earthquake][:h]),
			w: Settings.sections[:size][:w],
			h: Settings.disasters[:earthquake][:h]
		}
		@trigger_bg = Gosu::Color.argb 0xff_999999
		@trigger_fg = Gosu::Color.argb 0xff_000000
		@activated_at = 0
		@timeout = Time.now + (Settings.disasters[:earthquake][:timeout] * 2)
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
		# Draw earthquake trigger section
		if (Time.now > @timeout)
			# Background
			Gosu.draw_rect (@trigger[:x] - $camera.pos), @trigger[:y], @trigger[:w], @trigger[:h], @trigger_bg, 20
			# Text
			$resources[:earthquake_font].draw_rel "EARTHQUAKE", (@trigger[:x] + (@trigger[:w] / 2) - $camera.pos), @trigger[:y], 25, 0.5,-0.25, 1,1, @trigger_fg
		end
	end
end

