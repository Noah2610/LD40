### 80-80
@biomes = [:field]
@border = false
# Where buildings can spawn, center points
@build_levels = [
	{ x: 32, y: 85 },
	{ x: 64, y: 85 },
	{ x: 96, y: 85 }
]
# End points of sections, for nice ground flow
@end_point_heights = {
	left:  80,
	right: 80
}
# Points for people pathing
@people_path_points = [
	{ x: 16,  y: 90 },
	{ x: 48,  y: 90 },
	{ x: 80,  y: 90 },
	{ x: 112, y: 90 }
]
