extends Node2D

# Globals
const COLLISION_MASK_CARD = 1
const COLLISION_MASK_CARD_SLOT = 2

var offset_pos = 0
var card_being_dragged
var screen_size
var is_hovering_card

#Godot Functions
func _ready() -> void:
	screen_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x),clamp(mouse_pos.y, 0, screen_size.y)) 

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_action_pressed("left_click"):
			# Check for card with raycast
			var card = RaycastForCard()
			if card:
				StartDrag(card)
		else:
			FinishDrag()

# Created Functions
func RaycastForCard():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return GetCardHighestZ(result)
	else:
		return null
		
func RaycastForCardSlot():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = COLLISION_MASK_CARD_SLOT
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null
		
func GetCardHighestZ(card_array):
	var highest_z_card = card_array[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	for i in range(1, card_array.size()):
		var current_card = card_array[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index
	return highest_z_card
		
	
func ConnectCardSignals(card):
	card.connect("hovered", OnCardHover)
	card.connect("hovered_off", OnCardHoverOff)

func OnCardHover(card):
	if !is_hovering_card:
		is_hovering_card = true
		HighlightCard(card, true)
	
func OnCardHoverOff(card):
	if !card_being_dragged:
		HighlightCard(card, false)
		var new_card_hovered = RaycastForCard()
		if new_card_hovered:
			HighlightCard(new_card_hovered, true)
		else:
			is_hovering_card = false

func HighlightCard(card, hovered):
	if hovered:
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1)
		card.z_index = 1

func StartDrag(card):
	card_being_dragged = card
	card.scale = Vector2(1, 1)
	
func FinishDrag():
	if card_being_dragged:
		card_being_dragged.scale = Vector2(1.05, 1.05)
		var card_slot_found = RaycastForCardSlot()
		if card_slot_found:
			card_being_dragged.position.x = card_slot_found.position.x + offset_pos
			card_being_dragged.position.y = card_slot_found.position.y
			offset_pos += 50
			card_being_dragged.get_node("Area2D/CollisionShape2D").disabled = true
		card_being_dragged = null 
