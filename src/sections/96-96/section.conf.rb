### 96-96
@biomes = [:field]
@border = false
# Where buildings can spawn, center points
@build_levels = [
	{ x: 16,  y: 100 },
	{ x: 48,  y: 100 },
	{ x: 80,  y: 100 },
	{ x: 112, y: 100 }
]
# End points of sections, for nice ground flow
@end_point_heights = {
	left:  96,
	right: 96
}
# Points for people pathing
@people_path_points = [
	{ x: 16,  y: 105 },
	{ x: 48,  y: 105 },
	{ x: 80,  y: 105 },
	{ x: 112, y: 105 }
]
