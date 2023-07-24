extends Node2D

@onready var gb = Global

@onready var stats_label : Label = $UI/Control/StatsLabel
@onready var stats_pt_label : Label = $UI/Control/StatsPTLabel

var hold_improv = null
var hold_card = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if Input.is_action_pressed("action_click"):
		if not hold_improv:
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsPointQueryParameters2D.new()
			query.position = get_global_mouse_position()
			query.collide_with_areas = true
			query.collide_with_bodies = false
			var result = space_state.intersect_point(query)
			
			for collider in result:
				if collider.collider.is_in_group("card"):
					hold_card = collider.collider.get_parent()
					hold_improv = hold_card.improv_pre.instantiate()
					add_child(hold_improv)
					
					hold_improv.position = gb.cube_to_real_coords(gb.real_to_cube_coords(get_global_mouse_position()))
					break
				
			
		else:
			hold_improv.position = gb.cube_to_real_coords(gb.real_to_cube_coords(get_global_mouse_position()))
		
	elif Input.is_action_just_released("action_click"):
		if hold_improv:
			place_improv()
			$CardHand.remove_card(hold_card)
			hold_improv = null
			hold_card = null
		

func place_improv():
	var place_loc = gb.generate_hex_key(gb.real_to_cube_coords(get_global_mouse_position()))
	print(place_loc)
	if gb.grid.has(place_loc) and gb.grid[place_loc].improvement == null:
		remove_child(hold_improv)
		gb.grid[place_loc].add_improv(hold_improv) 
	else:
		hold_improv.queue_free()


func calc_turn():
	var stats = $HexGrid.calculate()
	
	gb.resources_pt = stats
	print(stats)
	
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

	stats_pt_label.text =  "Per turn:
						+%d
						+%d
						+%d
						+%d
						+%d" % [gb.resources_pt["food"], 
						gb.resources_pt["material"], 
						gb.resources_pt["labor"], 
						gb.resources_pt["science"], 
						gb.resources_pt["gold"]]


func _on_end_turn_button_pressed():
	calc_turn()
