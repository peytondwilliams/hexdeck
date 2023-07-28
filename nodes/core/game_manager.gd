extends Node2D

@onready var gb = Global

@onready var stats_label : Label = $UI/Control/StatsLabel
@onready var stats_pt_label : Label = $UI/Control/StatsPTLabel

@onready var card_hand : Node2D = $Camera2D/CardHand
@onready var card_shop : Node2D = $Camera2D/CardShop

var hold_improv = null
var hold_card = null

var prev_mouse_pos: Vector2 = Vector2.ZERO
var dragging = false

var tried_click_card = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	if Input.is_action_just_pressed("action_click"):
		if not hold_improv and not tried_click_card:
			dragging = true
			prev_mouse_pos = get_global_mouse_position()
			
	if Input.is_action_pressed("action_click"):
		if hold_improv:
			hold_improv.position = gb.cube_to_real_coords(gb.real_to_cube_coords(get_global_mouse_position()))
		elif dragging: #dragging
			var curr_mouse_pos = get_global_mouse_position()
			var lerped_vec = prev_mouse_pos.lerp(curr_mouse_pos, delta * 4)
			$Camera2D.position -= (lerped_vec - prev_mouse_pos) * 2
			prev_mouse_pos = lerped_vec
		
	elif Input.is_action_just_released("action_click"):
		if hold_improv:
			place_improv()
			hold_improv = null
			hold_card = null
		elif dragging:
			dragging = false
			
	tried_click_card = false

func place_improv():
	var place_loc = gb.generate_hex_key(gb.real_to_cube_coords(get_global_mouse_position()))
	if gb.grid.has(place_loc) and gb.grid[place_loc].improvement == null and hold_improv.is_valid_coords(place_loc):
		remove_child(hold_improv)
		gb.grid[place_loc].add_improv(hold_improv) 
		card_hand.play_card(hold_card)
	else:
		hold_improv.queue_free()


func calc_turn():
	var stats = $HexGrid.calculate()
	
	gb.resources_pt = stats
	
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

	stats_pt_label.text =  "Last turn:
						+%d
						+%d
						+%d
						+%d
						+%d" % [gb.resources_pt["food"], 
						gb.resources_pt["material"], 
						gb.resources_pt["labor"], 
						gb.resources_pt["science"], 
						gb.resources_pt["gold"]]

func trigger_relics(trig_type):
	for relic in gb.relics[gb.TRIG.keys()[trig_type]]:
		relic.activate()

func _on_end_turn_button_pressed():
	# end of turn actions
	trigger_relics(gb.TRIG.END_TURN)
	calc_turn()
	
	gb.turn += 1
	
	# start of turn actions
	card_hand.draw_hand()
	trigger_relics(gb.TRIG.START_TURN)


func _on_buy_card_button_pressed():
	card_shop.draw_shop()
	card_shop.visible = true


func _on_card_hand_card_click(card):
	tried_click_card = true
		
	if card_hand.can_play_card(card):
		hold_card = card
		hold_improv = card.improv_pre.instantiate()
		add_child(hold_improv)
		
		hold_improv.position = gb.cube_to_real_coords(gb.real_to_cube_coords(get_global_mouse_position()))
	
