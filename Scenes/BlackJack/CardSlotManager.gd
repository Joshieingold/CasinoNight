extends Node2D
const DEFAULT_MOVE_SPEED = 0.2
var database_reference
func _ready() -> void:
	database_reference = preload("res://Scenes/BlackJack/Database.gd")

func AddCardToHand(card, slot, faceup):
	slot.cards.insert(0, card)
	AnimateCardToPosition(card, Vector2(slot.position.x + slot.card_offset_pos, slot.position.y), DEFAULT_MOVE_SPEED)
	slot.AddPos()
func CheckValue(slot):
	print("------")
	print(slot.name)
	print("------")
	var hand_value = 0
	for card in slot.cards:
		var texture = card.get_node("CardImage").texture
		var path = texture.resource_path  # e.g. "res://cards/ace_of_spades.png"
		var parts = path.split("/")
		var card_parts = parts[4].split("_")
		var value = card_parts[0] 
		if (database_reference.CARDS).has(value):
			var points = database_reference.CARDS[value] 
			hand_value += points
		
		return hand_value
	
	
	
func AnimateCardToPosition(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
