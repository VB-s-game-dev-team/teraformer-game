extends Camera2D


export(float) var _MAX_ZOOM: float = 1 / 8.0
var _min_zoom: float = 1

func _ready() -> void:
	zoom = Vector2.ONE * _MAX_ZOOM

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.button_mask == BUTTON_RIGHT:
		position -= event.relative * zoom.x
		position.x = \
			max(limit_left, min(limit_right - get_viewport_rect().size.x, position.x))
		position.y = \
			max(limit_top, min(limit_bottom - get_viewport_rect().size.y, position.y))
	elif event is InputEventMouseButton:
		match event.button_index:
			BUTTON_WHEEL_UP:
				_zoom(1.1, event.position)
			BUTTON_WHEEL_DOWN: 
				_zoom(-1.1, event.position)

func _zoom(factor: float, where: Vector2) -> void:
	if factor < 0:
		factor = -1 / factor
	var pos1 := where * zoom.x
	zoom *= factor
	zoom = Vector2.ONE * min(_min_zoom, max(_MAX_ZOOM, zoom.x))
	var pos2 := where * zoom.x
	position += (pos1 - pos2)

func _on_MiningScreen_game_started() -> void:
	pass

func _on_GameBoard_bounds_updated(min_x, max_x, min_y, max_y) -> void:
	self.limit_left = min_x
	self.limit_right = max_x
	self.limit_top = min_y
	self.limit_bottom = max_y
