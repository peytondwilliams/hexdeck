extends Node2D

signal click(card)

@export var cost : Dictionary = {
	"food": 0,
	"material": 0,
	"labor": 0,
	"science": 0,
	"gold": 0
}

@onready var area : Area2D = $Area2D

var mouse_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and mouse_over:
		click.emit(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_2d_mouse_entered():
	mouse_over = true

func _on_area_2d_mouse_exited():
	mouse_over = false
