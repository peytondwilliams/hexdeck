extends "res://nodes/core/relic.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	trigger = gb.TRIG.END_TURN

func activate():
	gb.resources["labor"] += 1
