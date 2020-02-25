extends Node2D

var _planet_rotation_speed := 1.0
var _planet_rotation_direction := 0
var _planet_rotation_duration := 750.0
var _rotation_timer := OS.get_ticks_msec()
var _was_rotating := false
var rotation_position := 0

func _process(delta: float) -> void:
	if _rotation_timer + _planet_rotation_duration - 1000 * delta > OS.get_ticks_msec():
		rotate(delta * _planet_rotation_direction * _planet_rotation_speed * PI / 2)
	elif _was_rotating:
		_terminate_rotation()

# Set rotation variables and disable input	
func _initiate_rotation(new_direction: int)	-> void:
	_was_rotating = true
	get_tree().get_root().set_disable_input(true)
	_planet_rotation_direction = new_direction
	_planet_rotation_speed = 1000.0 / _planet_rotation_duration
	_rotation_timer = OS.get_ticks_msec()
	rotation_position = (rotation_position + new_direction) % 4

# Fix any rotation errors and enable input 
func _terminate_rotation() -> void:
	get_tree().get_root().set_disable_input(false)
	fix_rotation_error()
	_was_rotating = false

func fix_rotation_error() -> void:
	rotation = rotation_position * 0.5 * PI


func _on_LeftRotateButton_button_up() -> void:
	_initiate_rotation(1)


func _on_RightRotateButton_button_up() -> void:
	_initiate_rotation(-1)
