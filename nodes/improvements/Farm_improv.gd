extends Improvement

@export var stats : Dictionary = {
	"food": 3,
	"material": 0,
	"labor": 0,
	"science": 0,
	"gold": 0
}
# Called when the node enters the scene tree for the first time.
func _ready():
	id = "farm"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calculate():
	var calc_stats = stats.duplicate(true)
	
	for neighbor_str in Global.neighbors(Global.generate_hex_key(coords)):
		var n_improv = Global.grid[neighbor_str].improvement

		if n_improv and n_improv.id == "farm":
			calc_stats["food"] += 1
			
	return calc_stats
	
func is_valid_coords(check_coords: String):
	return Global.grid[check_coords].biome == "grass"
	
