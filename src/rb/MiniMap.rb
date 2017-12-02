
class MiniMap
	attr_reader :w
	def initialize args
		@sections = args[:sections]
		@x = 0
		@y = 0
		#@w = (@sections.size * Settings.sections[:size][:w])
		@w = args[:w] || Settings.screen[:w]
		@h = 64
		@bg_color = Gosu::Color.argb 0x66_dddddd
		@fg_color = Gosu::Color.argb 0x66_999999
		@sections_on_screen = @w.to_f / Settings.sections[:size][:w].to_f
		@scale = ((@w / Settings.sections[:image_size][:w].to_f) / @sections.size.to_f)
		@section_width = ((Settings.sections[:size][:w] * @scale) / 4)
		@view = {
			pos: 0,
			w:   (@sections_on_screen * @section_width / (@w.to_f / Settings.screen[:w].to_f)),
			h:   @h
		}
	end

	def update
		#@view[:pos] = sections_on_screen * $camera.get_pos_in_percent(:left).to_f
		@view[:pos] = (@w.to_f / 100.0) * $camera.get_pos_in_percent(:left).to_f
	end

	def draw
		# Draw background
		Gosu.draw_rect @x,@y, @w,@h, @bg_color, 10

		# Draw sections
		@sections.each_with_index do |section,index|
			if (section.inverted?)
				section.image.draw (((@w / @sections.size) * index) + @section_width), @y, 15, -@scale,0.5
			else
				section.image.draw ((@w / @sections.size) * index), @y, 15, @scale,0.5
			end
		end

		# Draw position
		Gosu.draw_rect @view[:pos],@y, @view[:w],@view[:h], @fg_color, 20
	end
end

