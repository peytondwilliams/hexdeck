extends Improvement

@export var stats : Dictionary = {
	"food": 2,
	"material": 0,
	"labor": 0,
	"science": 0,
	"gold": 0
}
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calculate():
	var calc_stats = stats.duplicate(true)
	
	for neighbor in Global.neighbors(Global.generate_hex_key(coords)):
		var n_improv = neighbor.improvement
		if n_improv and n_improv.id == "farm":
			calc_stats["food"] += 0.25
			
	return stats
	
