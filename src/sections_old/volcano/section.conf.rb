### volcano
@biomes = [:field]
@border = false
# Where buildings can spawn, center points
@build_levels = []
# End points of sections, for nice ground flow
@end_point_heights = {
	left:  100,
	right: 100
} # Points for people pathing
@people_path_points = [
	{ x: 16, y: 100 },
	{ x: 40, y: 90 },
	{ x: 80, y: 90 },
	{ x: 116, y: 100 }
]
@disaster = :volcano
