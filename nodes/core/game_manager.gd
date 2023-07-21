extends Node

@onready var gb = Global

@onready var stats_label : Label = $UI/Control/StatsLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func calc_turn():
	var stats = $HexGrid.calculate()
	
	for key in gb.resources.keys():
		#gb.resources[key] += gb.resources_pt[key]
		gb.resources[key] += stats[key]
		
	stats_label.text =  "Resources:
						Food: %d
						Material: %d
						Labor: %d
						Science: %d
						Gold: %d" % [gb.resources["food"], 
						gb.resources["material"], 
						gb.resources["labor"], 
						gb.resources["science"], 
						gb.resources["gold"]]


func _on_end_turn_button_pressed():
	calc_turn()
