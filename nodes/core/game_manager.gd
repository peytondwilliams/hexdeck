extends Node

@onready var gb = Global


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calc_turn():
	# var stats = $HexGrid.calc_turn()
	for key in gb.resources.keys():
		gb.resources[key] += gb.resources_pt[key]
	
