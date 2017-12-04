### 48-48
@biomes = [:field]
@border = false
# Where buildings can spawn, center points
@build_levels = [
	{ x: 16,  y: 54 },
	{ x: 48,  y: 54 },
	{ x: 80,  y: 54 },
	{ x: 112, y: 54 }
]
# End points of sections, for nice ground flow
@end_point_heights = {
	left:  48,
	right: 48
}
# Points for people pathing
@people_path_points = [
	{ x: 16,  y: 64 },
	{ x: 48,  y: 64 },
	{ x: 80,  y: 64 },
	{ x: 112, y: 64 }
]
