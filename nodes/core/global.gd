extends Node

const DIRECTION_ARR : Array = [
					Vector3i(+1, 0, -1), #mid right
					Vector3i(+1, -1, 0), #top right
					Vector3i(0, -1, +1), #top left
					Vector3i(-1, 0, +1), #mid left
					Vector3i(-1, +1, 0), #bot left
					Vector3i(0, +1, -1) #bot right
					]
					
const COORD_SCALE_FACTOR = 16

enum TRIG {START_TURN, END_TURN, PRE_TAX, PLAY_CARD, DRAW_CARD} #etc

var resources : Dictionary = {
	"food": 0,
	"material": 0,
	"labor": 0,
	"science": 0,
	"gold": 0
}
var resources_pt : Dictionary = {
	"food": 0,
	"material": 0,
	"labor": 0,
	"science": 0,
	"gold": 0
}
var grid : Dictionary = {}

var relics : Dictionary = {
	"START_TURN" : [],
	"END_TURN" : [],
	"PRE_TAX" : [],
	"PLAY_CARD" : [],
	"DRAW_CARD" : []
}

var deck : Array = []

var turn : int = 1


func generate_hex_key(coords: Vector3i):
	return str(coords.x) + "," + str(coords.y) + "," + str(coords.z)

func key_to_coords(coords_key: String):
	var coords_split = coords_key.split(",")
	return Vector3i(int(coords_split[0]), int(coords_split[1]), int(coords_split[2]))
	
func cube_to_real_coords(coords: Vector3i):
	var q = float(coords.x)
	var r = float(coords.y)
	var s = float(coords.z)

	var x = -sqrt(3) * ( r/2 + s )
	var z = r * 1.5
	return Vector2(x, z) * COORD_SCALE_FACTOR

func real_to_cube_coords(coords: Vector2):
	coords = coords / COORD_SCALE_FACTOR
	var q = (sqrt(3)/3 * coords.x  -  1./3 * coords.y)
	var r = (                        2./3 * coords.y)
	var s = (-q - r)
	return cube_round(Vector3(q, r, s))
	
func cube_round(coords: Vector3):
	var q = roundi(coords.x)
	var r = roundi(coords.y)
	var s = roundi(coords.z)

	var q_diff = abs(q - coords.x)
	var r_diff = abs(r - coords.y)
	var s_diff = abs(s - coords.z)

	if q_diff > r_diff and q_diff > s_diff:
		q = -r-s
	elif r_diff > s_diff:
		r = -q-s
	else:
		s = -q-r
	
	return Vector3i(q, r, s)

func cube_distance(a: Vector3i, b: Vector3i):
	return (abs(a.x - b.x) + abs(a.y - b.y) + abs(a.z - b.z)) / 2
	
func neighbors(coords_key: String):
	var base_coords = key_to_coords(coords_key)
	var found_neighbors = []
	for offset in DIRECTION_ARR:
		var new_coords_key = generate_hex_key(base_coords + offset)
		var neighbor_hex = grid.get(new_coords_key)
		if (neighbor_hex != null):
			# add check if terrain impassible
			found_neighbors.append(new_coords_key)
	return found_neighbors
