extends Node2D
class_name Improvement

@onready var DIRECTION_ARR : Array = Global.DIRECTION_ARR
@onready var grid : Dictionary = Global.grid
@onready var relics : Dictionary = Global.relics

@export var id: String = "farm"

var coords: Vector3i

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func init(new_coords: Vector3i):
	coords = new_coords
	
func calculate():
	pass
