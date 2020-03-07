extends Node2D

# Rotation variables
var _planet_rotation_speed := 1.0
var _planet_rotation_direction := 0
var _was_rotating := false
var rotation_position := 0  # Used for rotation fixing

var _total_delta := 0.0
var _max_delta := 1.0  # Duration

# Process
func _process(delta: float) -> void:
	if _total_delta <= _max_delta:
		_total_delta += delta
		rotate(delta * _planet_rotation_direction * _planet_rotation_speed * PI / 2)
	elif _was_rotating:
		_terminate_rotation()

# Set rotation variables and disable input	
func _initiate_rotation(new_direction: int)	-> void:
	_total_delta = 0.0
	_was_rotating = true
	get_tree().get_root().set_disable_input(true)
	_planet_rotation_direction = new_direction
	_planet_rotation_speed = 1.0 / _max_delta
	rotation_position = (rotation_position + new_direction) % 4

# Fix any rotation errors and enable input 
func _terminate_rotation() -> void:
	get_tree().get_root().set_disable_input(false)
	_fix_rotation_error()
	_was_rotating = false

# Fixes the rotation error caused by random factors
func _fix_rotation_error() -> void:
	rotation = rotation_position * 0.5 * PI

# Rotate clockwise
func _on_LeftRotateButton_button_up() -> void:
	_initiate_rotation(1)

# Rotate counterclockwise
func _on_RightRotateButton_button_up() -> void:
	_initiate_rotation(-1)
