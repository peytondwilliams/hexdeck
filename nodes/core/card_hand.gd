extends Node2D

@onready var farm_card = preload("res://nodes/cards/farm_card.tscn")

var cards = []
# Called when the node enters the scene tree for the first time.
func _ready():
	add_card("")
	add_card("")
	add_card("")


func add_card(card_name):
	var card = farm_card.instantiate()
	add_child(card)
	cards.append(card)
	card.position = Vector2.ZERO + Vector2(180, 0) * (cards.size() - 1)
	
	
func organize_hand():
	for i in range(0, cards.size()):
		var card = cards[i]
		card.position = Vector2.ZERO + Vector2(180, 0) * i
	
func remove_card(card: Node2D):
	for i in range(0, cards.size()):
		if cards[i] == card:
			cards.remove_at(i)
			remove_child(card)
			card.queue_free()
			organize_hand()
			return
	print("card not found")
	
func clear_hand():
	for i in range(cards.size() - 1, -1, -1):
		remove_child(cards[i])
		cards[i].queue_free()
	cards = []
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
