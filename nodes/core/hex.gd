extends Node2D

const DIRECTION_ARR = [
					Vector3i(+1, 0, -1), #mid right
					Vector3i(+1, -1, 0), #top right
					Vector3i(0, -1, +1), #top left
					Vector3i(-1, 0, +1), #mid left
					Vector3i(-1, +1, 0), #bot left
					Vector3i(0, +1, -1) #bot right
					]

var coords : Vector3i
@export var biome : String = "base"
var improvement : Node2D = null

@export var stats : Dictionary = {
	"food": 1,
	"material": 1,
	"labor": 1,
	"science": 1,
	"gold": 1
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_improv(new_improv):
	if improvement:
		improvement.queue_free()
	improvement = new_improv
	add_child(improvement)
	improvement.position = Vector2.ZERO
	improvement.init(coords)

func calculate():
	if improvement:
		return improvement.calculate()
	else:
		return {}
