extends Node2D

var deck_size = 52
var card_texture: Texture2D
var top_card: Sprite2D

func _ready() -> void:
	card_texture = preload("res://Assets/Cards/back_card.png")
	top_card = $Sprite2D

func GetPositionTopCard():
	return top_card.position
func UpdateSize(current_size):
	deck_size = current_size
	queue_redraw()
	
	
func _draw() -> void:
	var visible_cards = deck_size
	var scale = Vector2(4.031, 4)
	var tex_size = card_texture.get_size() * scale

	var stack_offset = Vector2.ZERO

	for i in range(visible_cards):
		var offset = Vector2(i / 1.5, i / 1.5)
		var rect = Rect2(offset, tex_size)
		draw_texture_rect(card_texture, rect, false)
		stack_offset = offset

	# --- Position the top card correctly ---
	# Account for texture size so it's aligned on top visually
	var texture_center_offset = tex_size / 2.0
	var card_position = stack_offset + texture_center_offset

	# Move the top card to that corrected position
	top_card.position = card_position
