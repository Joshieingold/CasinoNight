extends Node2D

const DEFAULT_CARD_MOVE_SPEED = 0.2
const CARD_WIDTH = 200

var hand_y_position
var player_hand = []
var center_screen_x


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand_y_position = get_viewport().size.y - 200
	center_screen_x = get_viewport().size.x / 2



func AddCardToHand(card, speed):
	if card not in player_hand:
		player_hand.insert(0, card)
		UpdateHandPositions(speed)
	else:
		AnimateCardToPosition(card, card.hand_position, DEFAULT_CARD_MOVE_SPEED)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func UpdateHandPositions(speed):
	for i in range(player_hand.size()):
		var new_position = Vector2(CalculateCardPosition(i), hand_y_position)
		var card = player_hand[i]
		card.hand_position = new_position
		AnimateCardToPosition(card, new_position, speed)
func CalculateCardPosition(index):
	var total_width = (player_hand.size() -1) * CARD_WIDTH
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return x_offset

func AnimateCardToPosition(card, new_position, speed):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, speed)
	
func RemoveCardFromHand(card):
	if card in player_hand:
		player_hand.erase(card)
		UpdateHandPositions(DEFAULT_CARD_MOVE_SPEED)
