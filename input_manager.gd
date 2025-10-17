extends Node2D

signal left_mouse_button_clicked
signal left_mouse_button_released

const COLLISION_MASK_CARD = 1
const COLLISION_MASK_DECK = 2 
var card_manager_refereence
var deck_reference

func _ready() -> void:
	card_manager_refereence = $"../CardManager"
	deck_reference = $"../Deck"

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			emit_signal("left_mouse_button_clicked")
			raycast_at_cursor()
		else:
			emit_signal("left_mouse_button_released")
func raycast_at_cursor():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == COLLISION_MASK_CARD:
			var card_found = result[0].collider.get_parent()
		elif result_collision_mask == COLLISION_MASK_DECK:
			deck_reference.DrawCard()
			
	else:
		return null
