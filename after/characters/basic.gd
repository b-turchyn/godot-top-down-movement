## Basic top-down movement implementation
## This is based directly on Godot's example implementation of top-down movement. It's good. Not
## much to tweak here. 
## https://docs.godotengine.org/en/4.3/tutorials/2d/2d_movement.html#way-movement

class_name BasicCharacter
extends CharacterBody2D

## The maximum speed allowed, in pixels per second
@export var max_speed: float = 200.0

func _physics_process(_delta: float) -> void:
	velocity = _direction() # * max_speed
	move_and_slide()

func _direction() -> Vector2:
	return Input.get_vector("left", "right", "up", "down")
