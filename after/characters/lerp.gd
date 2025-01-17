## This character uses [i]linear interpolation[/i] to reduce acceleration the closer we get
## to our top speed. This results in a similar curve to the steering function approach.

extends BasicCharacter
class_name LerpCharacter

@export var acceleration: float = 380.0
@export var friction: float = 100.0

func _physics_process(delta: float) -> void:
	var direction: Vector2 = _direction()
	
	if direction != Vector2.ZERO:
		# First, see if we're trying to turn. Without this, we can't turn or slow down easily.
		# Get the dot product between the two and decide how influential the turn force is.
		var angle_cosine: float = abs(velocity.normalized().dot(direction))
		var turn_factor: float = lerpf(1.0, 0.0, angle_cosine)
		# Reduce our acceleration based on how close we are to the maximum speed
		var speed_factor: float = lerpf(1.0, turn_factor, velocity.length() / max_speed)
		var adjusted_acceleration: float = acceleration * max(turn_factor, speed_factor)
		
		## This logging statement gives you some insight as you move around
		print("angle_cosine=%.2f\tturn_factor=%.2f\tspeed_factor=%.2f\tadjusted_acceleration=%.2f" % [angle_cosine, turn_factor, speed_factor, adjusted_acceleration])
		
		velocity += direction * adjusted_acceleration * delta
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
		
	move_and_slide()
	print("Speed: %.02f" % velocity.length())
