extends Camera2D


export(float) var _MAX_ZOOM: float = 8
var _min_zoom: float


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.button_mask == BUTTON_RIGHT:
		offset -= event.relative * zoom.x
	elif event is InputEventMouseButton:
		match event.button_index:
			BUTTON_WHEEL_UP:
				_zoom(1.1, event.position)
			BUTTON_WHEEL_DOWN: 
				_zoom(-1.1, event.position)

func _zoom(factor: float, where: Vector2) -> void:
	if factor < 0:
		factor = -1 / factor
	zoom *= factor
	var rel_pos := where - get_viewport_rect().size / 2
	offset += rel_pos
	offset -= rel_pos * factor 
	

func _on_MiningScreen_game_started() -> void:
	pass
