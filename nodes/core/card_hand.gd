extends Node2D

@onready var gb = Global

@onready var farm_card = preload("res://nodes/cards/farm_card.tscn")

var cards : Array = []
var draw_pile : Array = []
var discard_pile : Array = []
# Called when the node enters the scene tree for the first time.
func _ready():
	Global.deck.append(farm_card.instantiate())
	Global.deck.append(farm_card.instantiate())
	Global.deck.append(farm_card.instantiate())
	
	draw_hand()

func add_card(card_name):
	var card = farm_card.instantiate()
	add_child(card)
	cards.append(card)
	organize_hand()
		
func organize_hand():
	var start_pos = Vector2.ZERO - Vector2(90, 0) * (cards.size() - 1)
	
	for i in range(0, cards.size()):
		var card = cards[i]
		card.position = start_pos + Vector2(180, 0) * i
	
func play_card(card: Node2D):
	for i in range(0, cards.size()):
		if cards[i] == card:
			charge_card_cost(card)
			cards.remove_at(i)
			discard_pile.append(card)
			remove_child(card)
			organize_hand()
			return
	print("card not found")
	
func clear_hand():
	for i in range(cards.size() - 1, -1, -1):
		discard_pile.append(cards[i])
		remove_child(cards[i])
	cards = []
		
func draw_hand():
	clear_hand()
	
	for i in range(0, 3):
		if draw_pile.is_empty():
			reset_draw_pile()
		
		var card = draw_pile.pop_back()
		cards.append(card)
		add_child(card)
	
	organize_hand()
	
func reset_draw_pile():
	draw_pile = gb.deck.duplicate()
	for i in range(draw_pile.size() - 1, -1, -1):
		if cards.has(draw_pile[i]): # Optimize if necessary
			draw_pile.remove_at(i)

	draw_pile.shuffle()
	discard_pile = []
	
func can_play_card(card):
	for key in gb.resources.keys():
		if gb.resources[key] < card.cost[key]:
			return false

	return true
	
func charge_card_cost(card):
	for key in gb.resources.keys():
		gb.resources[key] -= card.cost[key]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
