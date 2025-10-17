extends Sprite2D

# Signals
signal hovered
signal hovered_off

# Godot functions
func _ready() -> void:
	get_parent().ConnectCardSignals(self)

# Personal Functions
func _on_area_2d_mouse_entered():
	emit_signal("hovered", self)
func _on_area_2d_mouse_exited():
	emit_signal("hovered_off", self)
	
