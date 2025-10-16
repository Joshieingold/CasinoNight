extends Node2D
var card_being_dragged
var screen_size
func _input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			print("click")
			var card =  raycast_check_for_card()
			if card:
				card_being_dragged = card;
			else:
				card_being_dragged = null
		else:
			card_being_dragged = null;
			
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size
func raycast_check_for_card():
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		return (result[0].collider.get_parent())
	else:
		return null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if card_being_dragged:
		var mouse_pos = get_global_mouse_position()
		card_being_dragged.position = Vector2(clamp(mouse_pos.x, 0, screen_size.x), clamp(mouse_pos.y, 0, screen_size.y))
		
func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
	
func on_hovered_over_card(card):
	HighlightCard(card, true)
	
func on_hovered_off_card(card):
	HighlightCard(card, false)
	
func HighlightCard(card, hovered):
	if hovered:
		card.scale = Vector2((card.scale).x + 0.2 ,(card.scale).y + 0.2)
		print("I KNOW YOU WENT IN")
	else:
		card.scale = Vector2((card.scale).x -0.2,(card.scale).y -0.2)
		card.z_index = 2
		print("exit!!")
	
