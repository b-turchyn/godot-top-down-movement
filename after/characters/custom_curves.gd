extends BasicCharacter
class_name CustomCurveCharacter

## What's the maximum acceleration in [code]pixels/s²[/code]. What's the value at the top of the curve?
@export var acceleration: float = 200.0
## The acceleration curve as a function of the current speed
@export var acceleration_curve: Curve
## 
@export var acceleration_time: float = 3.0
@export var deceleration: float = 200.0
@export var deceleration_curve: Curve
@export var deceleration_time: float = 3.0

func _ready() -> void:
	acceleration_curve.bake()
	deceleration_curve.bake()

func _physics_process(delta: float) -> void:
	var direction: Vector2 = _direction()
	
	## Are we accelerating?
	if direction != Vector2.ZERO:
		velocity += direction * acceleration_curve.sample(current_speed() / max_speed) * acceleration * delta
	else:
		# BUG: direction is 0 here, so we're not changing the value. We need a friction coefficient. 
		# velocity -= deceleration_curve.sample(current_speed() / max_speed) * deceleration * delta
		# Reduce the length of our velocity vector by a linear amount each frame
		var new_length = max(0, velocity.length() - (deceleration_curve.sample(current_speed() / max_speed) * deceleration * delta))
		velocity = velocity.normalized() * new_length
		
	velocity = velocity.limit_length(max_speed)
		
	move_and_slide()
	print("Speed: %f" % current_speed())

func current_speed() -> float: return velocity.length()
