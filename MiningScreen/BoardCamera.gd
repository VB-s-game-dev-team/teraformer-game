extends Camera2D


export(float) var _MAX_ZOOM: float = 8
var _min_zoom: float
var _DEFAULT_TILE_SIZE = 16


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.button_mask == BUTTON_RIGHT:
		offset -= event.relative * zoom.x
	elif event is InputEventMouseButton:
		match event.button_index:
			BUTTON_WHEEL_UP:
				var rel: Vector2 = offset - event.position
				zoom *= 1.1
				offset *= 1.1
			BUTTON_WHEEL_DOWN: 
				var rel: Vector2 = offset - event.position
				zoom /= 1.1
				offset /= 1.1

func _on_MiningScreen_game_started() -> void:
	pass#set_tile_size(_MAX_TILE_SIZE)
