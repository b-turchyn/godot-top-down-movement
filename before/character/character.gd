## This is your template for all exercises. Copy or modify this scene.

extends CharacterBody2D

func _physics_process(_delta: float) -> void:
	# These first two lines can be uncommented for the first exercise.
	# velocity = _direction() 
	# move_and_slide()
	pass

func _direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")
