extends Node2D

var deck_size = 52
var card_texture: Texture2D
var top_card: Sprite2D
var show_deck

func _ready() -> void:
	card_texture = preload("res://Assets/Cards/back_card.png")
	top_card = $Sprite2D
	$Sprite2D.visible = false


	

func GetPositionTopCard():
	return top_card.position
func UpdateSize(current_size):
	deck_size = current_size
	queue_redraw()
	
func PlayRiffleShuffle() -> void:
	if not card_texture:
		return

	var card_count = min(deck_size, 12)
	var half = card_count / 2
	var offset_x = 40
	var duration = 0.2
	var card_nodes_left: Array = []
	var card_nodes_right: Array = []

	# Hide the main deck while shuffling
	if has_node("Sprite2D"):
		$Sprite2D.visible = false
	show_deck = false
	queue_redraw()

	# Create temporary sprites for animation
	for i in range(card_count):
		var sprite = Sprite2D.new()
		sprite.texture = card_texture
		sprite.scale = Vector2(4.031, 4)
		sprite.position = top_card.position # start at the real deck position
		sprite.z_index = i
		add_child(sprite)

		if i < half:
			card_nodes_left.append(sprite)
		else:
			card_nodes_right.append(sprite)

	# --- Step 1: Lift and separate halves ---
	for i in range(half):
		if i < card_nodes_left.size():
			var s_left = card_nodes_left[i]
			var tween_l = create_tween()
			tween_l.tween_property(s_left, "position", top_card.position + Vector2(-offset_x, -i * 2.5), duration).set_trans(Tween.TRANS_SINE)
		if i < card_nodes_right.size():
			var s_right = card_nodes_right[i]
			var tween_r = create_tween()
			tween_r.tween_property(s_right, "position", top_card.position + Vector2(offset_x, -i * 4.5), duration).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(duration).timeout

	# --- Step 2: Interleave (riffle) animation ---
	var interleave_delay = 0.05
	var shuffled_nodes: Array = []
	for i in range(half):
		if i < card_nodes_left.size():
			var s = card_nodes_left[i]
			var tween = create_tween()
			tween.tween_property(s, "position", top_card.position + Vector2(0, -len(shuffled_nodes) * 0.7), duration).set_trans(Tween.TRANS_SINE)
			shuffled_nodes.append(s)
			await get_tree().create_timer(interleave_delay).timeout
		if i < card_nodes_right.size():
			var s = card_nodes_right[i]
			var tween = create_tween()
			tween.tween_property(s, "position", top_card.position + Vector2(0, -len(shuffled_nodes) * 0.7), duration).set_trans(Tween.TRANS_SINE)
			shuffled_nodes.append(s)
			await get_tree().create_timer(interleave_delay).timeout

	# --- Step 3: Collapse back into single stack ---
	await get_tree().create_timer(0.2).timeout
	for s in shuffled_nodes:
		var tween = create_tween()
		tween.tween_property(s, "position", top_card.position, duration).set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(duration).timeout

	# Cleanup temporary cards
	for s in shuffled_nodes:
		s.queue_free()
	for s in card_nodes_left:
		s.queue_free()
	for s in card_nodes_right:
		s.queue_free()

	# Show the real deck again and draw procedural stack
	if has_node("Sprite2D"):
		$Sprite2D.visible = true
	show_deck = true
	queue_redraw()



func _draw() -> void:
	if show_deck:
		var visible_cards = deck_size
		var scale = Vector2(4.031, 4)
		var tex_size = card_texture.get_size() * scale
		var compression = 0.2
		var total_offset = Vector2(-visible_cards * compression, visible_cards * compression)
		var stack_origin = -tex_size / 2.0 - total_offset / 2.0
		var stack_offset = Vector2.ZERO
		for i in range(visible_cards):
			var offset = Vector2(i * compression, -i * compression)
			var rect = Rect2(stack_origin + offset, tex_size)
			draw_texture_rect(card_texture, rect, false)
			stack_offset = offset
		var texture_center_offset = tex_size / 2.0
		var card_position = stack_origin + stack_offset + texture_center_offset
		top_card.position = card_position
