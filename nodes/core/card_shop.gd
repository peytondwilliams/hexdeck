extends Node2D


@onready var farm_card = preload("res://nodes/cards/farm_card.tscn")
@onready var mine_card = preload("res://nodes/cards/mine_card.tscn")

@onready var gb = Global

var cards : Array = []

func _ready():
	visible = false

func organize_hand():
	var start_pos = Vector2.ZERO - Vector2(90, 0) * (cards.size() - 1)
	
	for i in range(0, cards.size()):
		var card = cards[i]
		card.position = start_pos + Vector2(180, 0) * i
	
func clear_shop():
	for i in range(cards.size() - 1, -1, -1):
		cards[i].click.disconnect(_on_card_click)
		remove_child(cards[i])
	cards = []
		
func draw_shop():
	clear_shop()
	
	for i in range(0, 3):		
		random_card()
	
	organize_hand()
	
func random_card():
	var card = mine_card.instantiate() #TODO choose valid card for shop
	cards.append(card)
	add_child(card)
	card.click.connect(_on_card_click)
	
	organize_hand()

	
func _on_card_click(card):
	gb.deck.append(card)
	card.click.disconnect(_on_card_click)
	remove_child(card)

	visible = false
	# close shop ui
