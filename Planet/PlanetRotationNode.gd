extends Node2D

var rotation_position := 0

func _process(delta: float) -> void:
	pass
	
func fix_rotation_error() -> void:
	rotation = rotation_position * 0.5 * PI
