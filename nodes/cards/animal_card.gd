extends "res://nodes/core/card.gd"

@onready var improv_pre = preload("res://nodes/improvements/animal_improv.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	cost = {
		"food": 0,
		"material": 0,
		"labor": 1,
		"science": 0,
		"gold": 0
	}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

