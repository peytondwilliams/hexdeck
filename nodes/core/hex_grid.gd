extends Node2D

const HEX = preload("res://nodes/core/hex.tscn")

const DIRECTION_ARR = [
					Vector3i(+1, 0, -1), #mid right
					Vector3i(+1, -1, 0), #top right
					Vector3i(0, -1, +1), #top left
					Vector3i(-1, 0, +1), #mid left
					Vector3i(-1, +1, 0), #bot left
					Vector3i(0, +1, -1) #bot right
					]
					
const COORD_SCALE_FACTOR = 16

@onready var hex_grid : Dictionary = Global.grid

@onready var farms = preload("res://nodes/improvements/farm_improv.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_map()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("action_leftclick"):
	#	var events = InputMap.action_get_events("action_leftclick")
	pass


func generate_map():
	var curr_coords : Vector3i = Vector3i.ZERO

	for i in range(10):
		for j in range(10):
			var hex = HEX.instantiate()
			$Hexes.add_child(hex)

			hex.coords = curr_coords
			hex.position = Global.cube_to_real_coords(curr_coords)
			
			hex.add_improv(farms.instantiate())

			hex_grid[Global.generate_hex_key(curr_coords)] = hex

			curr_coords += DIRECTION_ARR[0]
		curr_coords += (DIRECTION_ARR[3] * 10)
		curr_coords += DIRECTION_ARR[5]
		if (i % 2 == 1):
			curr_coords += DIRECTION_ARR[3]
			

func calculate():
	var stats : Dictionary = {
		"food": 0,
		"material": 0,
		"labor": 0,
		"science": 0,
		"gold": 0
	}
	for hex in $Hexes.get_children():
		increment_stats(stats, hex.calculate())
		
	return stats
		

func increment_stats(main_stats : Dictionary, incr_stats : Dictionary):
	for key in incr_stats.keys():
		main_stats[key] += incr_stats[key]




func _on_player_select_hex(coords: Vector3i):
	#var hex_dict = hex_grid[generate_hex_key(coords)]
	#if (hex_dict["work_units"].size() > 0):
	pass
		# select unit
		#print("select unit")
		
	#print("moving unit")
	# TODO  _on_player_move_unit($Pawn, coords)
	#rpc("move_unit", "", coords)
	#move_unit("", coords)
		
func dist_heuristic(goal: String, current: String):
	pass
	#return cube_distance(key_to_coords(goal), key_to_coords(current))
