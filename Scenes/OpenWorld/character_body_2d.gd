extends CharacterBody2D
# CONSTANTS
var chips = 5000
var max_speed = 100;
var last_direction = Vector2(1, 0);

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down");
	
	velocity = direction * max_speed;
	move_and_slide();
	if Input.is_action_pressed("play_slots"):
		get_tree().change_scene_to_file("res://Scenes/BlackJack/BlackJack.tscn")
	if direction.length() > 0:
		last_direction = direction;
		PlayWalkAnimation(direction);
	else:
		PlayIdleAnimation(last_direction)
func PlayWalkAnimation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("walk_right");
	elif direction.x < 0:
		$AnimatedSprite2D.play("walk_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("walk_down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("walk_up")
		
func PlayIdleAnimation(direction):
	if direction.x > 0:
		$AnimatedSprite2D.play("idle_right");
	elif direction.x < 0:
		$AnimatedSprite2D.play("idle_left")
	elif direction.y > 0:
		$AnimatedSprite2D.play("idle_down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("idle_up")
