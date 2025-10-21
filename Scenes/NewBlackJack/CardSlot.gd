extends Node2D
var database_reference
var cards = []
var card_offset_pos = 0
var hand_value = 0

func _ready() -> void:
	database_reference = preload("res://Scenes/NewBlackJack/Database.gd")
func AddPos():
	card_offset_pos += 40

func AddCard(card):
	cards.insert(0, card)
	print(cards)
	hand_value = FindHandValue()
	print("you have: " + str(hand_value) + " points")
	return

func FindHandValue():
	hand_value = 0
	for card in cards:
		var card_parts = card.split("_")
		var value = card_parts[0] 
		if (database_reference.CARDS).has(value):
			var points = database_reference.CARDS[value] 
			hand_value += int(points)
		
	return hand_value
func Clear():
	cards = []
	hand_value = 0
	card_offset_pos = 0
	
