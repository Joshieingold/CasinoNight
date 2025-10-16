# Extend CharacterBody2D
extends CharacterBody2D

# Set speed in pixels per second
@export var speed = 400

func _physics_process(_delta):
	# Get input vector (up, down, left, right)
	var direction = Input.get_vector("left", "right", "up", "down")
	
	# Set velocity based on input direction and speed
	velocity = direction * speed
	
	# Move the player and handle collisions
	move_and_slide()
