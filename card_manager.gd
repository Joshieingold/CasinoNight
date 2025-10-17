extends Node2D
var card_being_dragged
var screen_size
var is_hovering_card

# Godot functions
func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			print("click")
			var card =  RaycastForCard()
			if card:
				card_being_dragged = card;
			else:
				card_being_dragged = null
		else:
			OnLeftClickReleased()
			
func _ready() -> void:
	screen_size = get_viewport_rect().size
	
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), clamp(mouse_pos.y, 0, screen_size.y))
		
# Personal functions
func OnLeftClickReleased():
	card_being_dragged = null
	

# Checks if the mouse goes over a card
func RaycastForCard():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return GetCardWithHigestZIndex(result)
	else:
		return null

# Should return the card that is currently on top
func GetCardWithHigestZIndex(cards):
	var highest_z_card = cards[0].collider.get_parent()
	var highest_z_index = highest_z_card.z_index
	for i in range(1, cards.size()):
		var current_card = cards[i].collider.get_parent()
		if current_card.z_index > highest_z_index:
			highest_z_card = current_card
			highest_z_index = current_card.z_index;
	return highest_z_card;
		
# Connects to the card with so we can use their signals
func ConnectCardSignals(card):
	card.connect("hovered", OnCardHover)
	card.connect("hovered_off", OnHoverOffCard)
	
# Affects what happens when a card is hovered
func OnCardHover(card):
	if !is_hovering_card:
		is_hovering_card = true
		HighlightCard(card, true)
		
# Handles hovering off of cards
func OnHoverOffCard(card):
	HighlightCard(card, false)
	var new_card_hovered = RaycastForCard()
	if new_card_hovered:
		HighlightCard(new_card_hovered, true)
	else:
		is_hovering_card = false
	
# Helper for highligh card, handles the highlight options
func HighlightCard(card, hovered):
	if hovered:
		if !card_being_dragged:
			card.scale = Vector2((card.scale).x + 0.2 ,(card.scale).y + 0.2)
	else:
		if !card_being_dragged:
			card.scale = Vector2((card.scale).x -0.2,(card.scale).y -0.2)
			card.z_index = 2
