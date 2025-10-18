extends Node2D

# Signals
signal hovered
signal hovered_off

var hand_position

func _ready() -> void:
	get_parent().ConnectCardSignals(self)
	
# Functions
func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered", self)

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off", self)
