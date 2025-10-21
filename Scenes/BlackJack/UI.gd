extends Node2D

	

func _ready() -> void:
	$HitButton/hit_collision.get_parent().collision_mask = 7
	$StandButton/stand_collision.get_parent().collision_mask = 6
	$DoubleButton/double_collision.get_parent().collision_mask = 5
