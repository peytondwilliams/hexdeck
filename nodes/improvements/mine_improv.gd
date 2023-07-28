extends Improvement

@export var stats : Dictionary = {
	"food": 0,
	"material": 2,
	"labor": 0,
	"science": 0,
	"gold": 0
}
# Called when the node enters the scene tree for the first time.
func _ready():
	id = "mine"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calculate():
	var calc_stats = stats.duplicate(true)
	
	for neighbor_str in Global.neighbors(Global.generate_hex_key(coords)):
		var n_hex = Global.grid[neighbor_str]

		if n_hex and n_hex.biome == "hill":
			calc_stats["material"] += 1
			
	return calc_stats
	
func is_valid_coords(check_coords: String):
	return Global.grid[check_coords].biome == "hill"
	
