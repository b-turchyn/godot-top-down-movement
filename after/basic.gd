extends Node2D

@onready var chart: Chart = %Chart
@export var character: CharacterBody2D:
	set(val):
		if character: character.queue_free()
		character = val
		add_child(val)

# The various characters
@onready var basic_character: PackedScene = preload("res://characters/basic.tscn")
@onready var linear_character: PackedScene = preload("res://characters/linear.tscn")
@onready var lerp_character: PackedScene = preload("res://characters/lerp.tscn")
@onready var steering_character: PackedScene = preload("res://characters/steering.tscn")
@onready var easing_character: PackedScene = preload("res://characters/ease.tscn")
@onready var custom_curves_character: PackedScene = preload("res://characters/custom_curves.tscn")

var f1: Function

func _ready():
	call_deferred("_on_basic_button_pressed")
	chart.set_y_domain(0.0, 200.0)
	chart.x_labels_function = func (_x: Variant) -> String: return ""
	
	var x: PackedFloat32Array = PackedFloat32Array(_array_of_range(15 * Engine.physics_ticks_per_second, 0))
	var y: Array = Array(_array_of_with(15 * Engine.physics_ticks_per_second, 0))
	
	# Let's customize the chart properties, which specify how the chart
	# should look, plus some additional elements like labels, the scale, etc...
	var cp: ChartProperties = ChartProperties.new()
	cp.colors.frame = Color("#161a1d", 0.7)
	cp.colors.background = Color.TRANSPARENT
	cp.colors.grid = Color("#283442")
	cp.colors.ticks = Color("#283442")
	cp.colors.text = Color.WHITE_SMOKE
	cp.draw_bounding_box = false
	cp.y_label = "Speed"
	cp.x_scale = 5
	cp.y_scale = 10
	cp.max_samples = 15 * Engine.physics_ticks_per_second # 15 seconds of physics time
	cp.interactive = false # false by default, it allows the chart to create a tooltip to show point values
	# and interecept clicks on the plot
	
	# Let's add values to our functions
	f1 = Function.new(
		x, y, "Speed", # This will create a function with x and y values taken by the Arrays 
						# we have created previously. This function will also be named "Pressure"
						# as it contains 'pressure' values.
						# If set, the name of a function will be used both in the Legend
						# (if enabled thourgh ChartProperties) and on the Tooltip (if enabled).
		# Let's also provide a dictionary of configuration parameters for this specific function.
		{ 
			color = Color("#36a2eb"), 		# The color associated to this function
			marker = Function.Marker.NONE, 	# The marker that will be displayed for each drawn point (x,y)
											# since it is `NONE`, no marker will be shown.
			type = Function.Type.LINE, 		# This defines what kind of plotting will be used, 
											# in this case it will be a Linear Chart.
			interpolation = Function.Interpolation.LINEAR	# Interpolation mode, only used for 
															# Line Charts and Area Charts.
		}
	)
	
	# Now let's plot our data
	chart.plot([f1], cp)
	
	# Uncommenting this line will show how real time data plotting works
	# set_process(false)


var new_val: float = 15.0 * Engine.physics_ticks_per_second

func _physics_process(_delta: float) -> void:
	if !character: return
	# This function updates the values of a function and then updates the plot
	new_val += 1
	
	# we can use the `Function.add_point(x, y)` method to update a function
	f1.add_point(new_val, character.velocity.length())
	# f1.remove_point(0)
	chart.queue_redraw() # This will force the Chart to be updated

func _array_of_range(size: int, starting_value: float) -> Array[Variant]:
	var result := Array()
	var val := starting_value
	for i in size:
		result.append(val)
		val += 1.0
	return result
	
func _array_of_with(size: int, initial_value: Variant) -> Array[Variant]:
	var result := Array()
	for i in size:
		result.append(initial_value)
	return result
	
func _set_character(character_scene: PackedScene) -> void:
	var new_character = character_scene.instantiate() as CharacterBody2D
	character = new_character

func _on_basic_button_pressed() -> void:
	_set_character(basic_character)

func _on_linear_button_pressed() -> void:
	_set_character(linear_character)

func _on_lerp_button_pressed() -> void:
	_set_character(lerp_character)

func _on_steering_button_pressed() -> void:
	_set_character(steering_character)

func _on_ease_button_pressed() -> void:
	_set_character(easing_character)

func _on_custom_curves_button_pressed() -> void:
	_set_character(custom_curves_character)
