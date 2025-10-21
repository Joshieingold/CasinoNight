extends Node2D
var game_manager_reference = preload("res://Scenes/NewBlackJack/BlackJackManager.gd")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	emit_signal("stand")
		
