extends Camera2D


signal transform_changed(t)

export(float) var _MAX_ZOOM: float = 1 / 50.0
var _min_zoom: float = 1

var _limit_left: int
var _limit_right: int
var _limit_top: int
var _limit_bottom: int

var _size: Vector2

func _ready() -> void:
	call_deferred("_actually_ready")

func _actually_ready() -> void:
	
	_size = get_viewport_rect().size
	zoom = Vector2.ONE * _MAX_ZOOM
	_clamp_pos()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.button_mask == BUTTON_RIGHT:
		position -= event.relative * zoom.x
		_clamp_pos()
	elif event is InputEventMouseButton:
		match event.button_index:
			BUTTON_WHEEL_UP:
				_zoom(1.1, event.position)
			BUTTON_WHEEL_DOWN: 
				_zoom(-1.1, event.position)

func _clamp_pos() -> void:
	position.x = \
		max(_limit_left, min(_limit_right - (_size.x * zoom.x), position.x))
	position.y = \
		max(_limit_top, min(_limit_bottom - (_size.y * zoom.y), position.y))
	emit_signal("transform_changed", Rect2(position, zoom))

func _zoom(factor: float, where: Vector2) -> void:
	if factor < 0:
		factor = -1 / factor
	var n_zoom := Vector2.ONE * min(_min_zoom, max(_MAX_ZOOM, zoom.x * factor))
	if n_zoom == zoom:
		return
	var pos1 := where * zoom.x
	var pos2 := where * n_zoom.x
	zoom = n_zoom
	position += (pos1 - pos2)
	_clamp_pos()

func _on_MiningScreen_game_started() -> void:
	pass

func _on_GameBoard_bounds_updated(min_x, max_x, min_y, max_y) -> void:
	_limit_left = min_x
	_limit_right = max_x
	_limit_top = min_y
	_limit_bottom = max_y
	
	_min_zoom = \
		min((_limit_right - _limit_left) / _size.x, (_limit_bottom - _limit_top) / _size.y)
	_clamp_pos()
