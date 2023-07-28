extends Node2D

const HEX = preload("res://nodes/core/hex.tscn")

const GRASS_HEX = preload("res://nodes/tiles/grass_hex.tscn")
const FOREST_HEX = preload("res://nodes/tiles/forest_hex.tscn")
const HILL_HEX = preload("res://nodes/tiles/hill_hex.tscn")
const WATER_HEX = preload("res://nodes/tiles/water_hex.tscn")



const DIRECTION_ARR = [
					Vector3i(+1, 0, -1), #mid right
					Vector3i(+1, -1, 0), #top right
					Vector3i(0, -1, +1), #top left
					Vector3i(-1, 0, +1), #mid left
					Vector3i(-1, +1, 0), #bot left
					Vector3i(0, +1, -1) #bot right
					]
					
const COORD_SCALE_FACTOR = 16
const CHUNK_SIZE_FACTOR = 16
const BOARD_SIZE_DIM = 20

@onready var hex_grid : Dictionary = Global.grid

@onready var farms = preload("res://nodes/improvements/farm_improv.tscn")

@onready var gb = Global

var moisture = FastNoiseLite.new()
var temperature = FastNoiseLite.new()
var altitude = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	moisture.seed = randi()
	temperature.seed = randi()
	altitude.seed = randi()
	altitude.frequency = 0.02
	
	generate_map()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#if Input.is_action_just_pressed("action_leftclick"):
	#	var events = InputMap.action_get_events("action_leftclick")
	pass


func generate_map():
	var curr_coords : Vector3i = Vector3i.ZERO

	var scale_moist = 10
	var scale_alt = 50
	var scale_temp = 30

	for i in range(BOARD_SIZE_DIM):
		for j in range(BOARD_SIZE_DIM):
			
			var coord = gb.cube_to_real_coords(curr_coords) / COORD_SCALE_FACTOR
			print(coord)
			
			var moist = moisture.get_noise_2d(coord.x * scale_moist, coord.y * scale_moist)
			var temp = temperature.get_noise_2d(coord.x * scale_temp, coord.y * scale_temp)
			var alt = altitude.get_noise_2d(coord.x * scale_alt, coord.y * scale_alt)

			
			var hex = null
			
			if moist > 0.2 and alt < 0.1:
				hex = WATER_HEX.instantiate()
			elif alt > 0.1 and moist < 0:
				hex = HILL_HEX.instantiate()
			elif temp > 0.1:
				hex = FOREST_HEX.instantiate()
			else:
				hex = GRASS_HEX.instantiate()
			
			$Hexes.add_child(hex)

			hex.coords = curr_coords
			hex.position = Global.cube_to_real_coords(curr_coords)
			
			#hex.add_improv(farms.instantiate())

			hex_grid[Global.generate_hex_key(curr_coords)] = hex

			curr_coords += DIRECTION_ARR[0]
		curr_coords += (DIRECTION_ARR[3] * BOARD_SIZE_DIM)
		curr_coords += DIRECTION_ARR[5]
		if (i % 2 == 1):
			curr_coords += DIRECTION_ARR[3]
			

func generate_chunk(offset):
	for x in range(CHUNK_SIZE_FACTOR):
		for y in range(CHUNK_SIZE_FACTOR):
			pass
	


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
