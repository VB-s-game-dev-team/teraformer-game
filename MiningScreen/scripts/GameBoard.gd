extends TileMap

class_name GameBoard

signal bounds_updated(min_x, max_x, min_y, max_y)

enum tiles{
	RESERVED = -3,
	EMPTY = -2,     #just some mess to make more types of empty tiles
	CLEARED = -1,
	HIDEN = 0,
	YELLOW = 1,
	RED = 2,
	GREEN = 3,
	BLUE = 4,
	DIRT = 5,
	STONE = 6
}

export(int) var _INIT_SIZE: int = 5

export(float) var TILE_SIZE: float = 16
export(int) var MIN_CHAIN_LENGTH: int = 3

var _min_x: int
var _min_y: int
var _max_x: int
var _max_y: int

var _stone_generator := OpenSimplexNoise.new()

var _mouse_transform := Rect2(0, 0, 1, 1)

var _falling_tile_resource: PackedScene

var _tiles_waiting_for_fall = []
var _tiles_trigered := false

var selected_points: Line2D
var selected_point_set := Dictionary()


func _ready() -> void:
	_falling_tile_resource = load("res://MiningScreen/scenes/FallingTile.tscn")
	
	selected_points = $SelectedPoints as Line2D
	
	_stone_generator.seed = randi()
	_stone_generator.octaves = 1
	_stone_generator.period = 5

func _process(_delta: float) -> void:
	_tiles_trigered = false

func _input(event: InputEvent) -> void:
	var pos: Vector2
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		pos = _tile_pos(_transform_mouse_pos(event.position))
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				_add_selected_point(pos)
			else:
				_break_selected_tiles()
	elif event is InputEventMouseMotion:
		if event.button_mask == BUTTON_LEFT:
			_add_selected_point(pos)

func _on_MiningScreen_game_started() -> void:
	clear()
	for i in range(0, _INIT_SIZE):
		for j in range(0, _INIT_SIZE):
			_break_tile(i, j)

func _random_color() -> int:
	return randi() % 4 + tiles.YELLOW

func _break_tile(x: int, y: int) -> void:
	var is_color := _is_tile_color(x, y)
	for i in range(x - 1, x + 2):
		for j in range(y - 1, y + 2):
			_uncover_tile(i, j)
	_set_tile(x, y, tiles.EMPTY)
	
	if is_color:
		for i in range(x - 1, x + 2):
			for j in range(y - 1, y + 2):
				if _can_tile_be_exploded(i, j):
					_break_tile(i, j)

func _uncover_tile(x: int, y: int):
	if get_cell(x, y) == tiles.HIDEN:
		var tile: int = tiles.DIRT
		if _stone_generator.get_noise_2d(x, y) < y / 500.0:
			tile = tiles.STONE
		_set_tile(x, y, tile)
	for i in range(x - 1, x + 2):
		for j in range(y - 1, y + 2):
			if get_cell(i, j) == -1:
				_set_tile(i, j, tiles.HIDEN)

func _set_tile(x: int, y: int, v: int) -> void:
	if y < 0:
		return
	
	set_cell(x, y, v)
	if v < 0:
		_tiles_waiting_for_fall.append({"x": x, "y": y})
		call_deferred("_trigger_empty_tiles_if_needed")
	
	var changed := false
	var changed_x: int = 0
	var changed_y: int = 0
	
	if _min_x > x:
		changed_x = x - _min_x
		_min_x = x
		changed = true
	if _max_x < x:
		changed_x = x - _max_x
		_max_x = x
		changed = true
	if _min_y > y:
		changed_y = y - _min_y
		_min_y = y
		changed = true
	if _max_y < y:
		changed_y = y - _max_y
		_max_y = y
		changed = true
	
	if changed:
		var rx
		var ry
		if changed_x != 0:
			ry = range(_min_y, _max_y + 1)
			if changed_x < 0:
				rx = range(_min_x, _min_x - changed_x + 1)
			else:
				rx = range(_max_x - changed_x + 1, _max_x + 1)
			_fix_exposedtiles(rx, ry)
		
		if changed_y != 0:
			rx = range(_min_x, _max_x + 1)
			if changed_y < 0:
				ry = range(_min_y, _min_y - changed_y + 1)
			else:
				ry = range(_max_y - changed_y + 1, _max_y + 1)
			_fix_exposedtiles(rx, ry)
		
		emit_signal("bounds_updated", \
			_min_x * TILE_SIZE, (_max_x + 1) * TILE_SIZE, \
			_min_y * TILE_SIZE, (_max_y + 1) * TILE_SIZE)

func _fix_exposedtiles(rx, ry):
	for x in rx:
		for y in ry:
			if get_cell(x, y) == tiles.CLEARED:
				#not using _set_tile() to avoid trigering bound update again
				set_cell(x, y, tiles.HIDEN)

func _put_random_color(x: int, y: int) -> void:
	_set_tile(x, y, _random_color())

func _transform_mouse_pos(pos: Vector2) -> Vector2:
	return pos * _mouse_transform.size.x + _mouse_transform.position

func _tile_pos(pos: Vector2) -> Vector2:
	if pos.x < 0:
		pos.x -= TILE_SIZE
	if pos.y < 0:
		pos.y -= TILE_SIZE
	pos /= TILE_SIZE
	pos.x = int(pos.x)
	pos.y = int(pos.y)
	return pos

func _on_BoardCamera_transform_changed(t) -> void:
	_mouse_transform = t

func _begin_fall(x: int, y: int, only_down: bool = false):
	var falling_tile_x: int
	var falling_tile_y: int
	var falling_tile_color: int
	
	if get_cell(x, y) >= 0 or get_cell(x, y) == tiles.RESERVED:
		_tiles_waiting_for_fall.append({"x": x, "y": y})
		return
	
	if y == 0:
		falling_tile_x = x
		falling_tile_y = -1
		falling_tile_color = \
			tiles.YELLOW + randi() % (tiles.BLUE - tiles.YELLOW + 1)
	else:
		if _is_tile_color(x, y - 1):
			falling_tile_x = x
			falling_tile_y = y - 1
		elif not only_down:
			if _is_tile_color(x - 1, y - 1):
				falling_tile_x = x - 1
				falling_tile_y = y - 1
			else:
				if _is_tile_color(x + 1, y - 1):
					falling_tile_x = x + 1
					falling_tile_y = y - 1
				else:
					_tiles_waiting_for_fall.append({"x": x, "y": y})
					return
		else:
			_tiles_waiting_for_fall.append({"x": x, "y": y})
			return
		falling_tile_color = get_cell(falling_tile_x, falling_tile_y)
		_begin_fall(falling_tile_x, falling_tile_y)
				
	var falling_tile := _falling_tile_resource.instance()
	_set_tile(falling_tile_x, falling_tile_y, tiles.EMPTY)
	_set_tile(x, y, tiles.RESERVED)
	add_child(falling_tile)
	falling_tile.setup( \
		{"x": x, "y": y, "color": falling_tile_color, "node": falling_tile}, \
		falling_tile_color, \
		Vector2(falling_tile_x * TILE_SIZE, falling_tile_y * TILE_SIZE), \
		Vector2(x * TILE_SIZE, y * TILE_SIZE))
	var connect_error := falling_tile.connect("done", self, "_end_fall")
	if connect_error != 0:
		print("error with falling tiles for some reason: " + str(connect_error))
	return true

func _end_fall(data) -> void:
	_set_tile(data.x, data.y, data.color)
	remove_child(data.node)
	data.node.call_deferred("free")
	call_deferred("_trigger_empty_tiles_if_needed")

func _trigger_empty_tiles() -> void:
	var tmp = _tiles_waiting_for_fall
	_tiles_waiting_for_fall = []
	while tmp.size() > 0:
		var coords = tmp.pop_back()
		_begin_fall(coords.x, coords.y, true)
	
	tmp = _tiles_waiting_for_fall
	_tiles_waiting_for_fall = []
	while tmp.size() > 0:
		var coords = tmp.pop_back()
		_begin_fall(coords.x, coords.y)

func _is_tile_color(x: int, y: int) -> bool:
	var tile := get_cell(x, y)
	return tile >= tiles.YELLOW and tile <= tiles.BLUE

func _add_selected_point(pos: Vector2) -> void:
	var too_far := false
	
	if not _is_tile_color(int(pos.x), int(pos.y)):
		return
	
	if selected_points.get_point_count() == 0:
		selected_points.selected_color = get_cellv(pos)
	else:
		var last_point = selected_points.get_point_position(
				selected_points.get_point_count() - 1)
		if abs(pos.x - last_point.x) > 1 or abs(pos.y - last_point.y) > 1:
			too_far = true
		if get_cellv(pos) != selected_points.selected_color:
			return
	
	if selected_point_set.has(pos):
		while selected_points.get_point_count() > selected_point_set[pos] + 1:
			var index = selected_points.get_point_count() - 1
			# warning-ignore:return_value_discarded
			selected_point_set.erase(selected_points.get_point_position(index))
			selected_points.remove_point(index)
		return
	elif too_far:
		return
	
	selected_point_set[pos] = selected_points.get_point_count()
	selected_points.add_point(pos)

func _break_selected_tiles() -> void:
	var index := selected_points.get_point_count() - 1
	var long_enough := selected_points.get_point_count() >= MIN_CHAIN_LENGTH
	while index >=  0:
		var pos = selected_points.get_point_position(index)
		if long_enough:
			_break_tile(pos.x, pos.y)
		selected_points.remove_point(index)
		index -= 1
	selected_points.clear_points()
	selected_point_set.clear()

func _can_tile_be_exploded(x: int, y: int) -> bool:
	var tile := get_cell(x, y)
	return tile == tiles.DIRT or tile == tiles.STONE

func _trigger_empty_tiles_if_needed() -> void:
	if _tiles_trigered:
		return
	call_deferred("_trigger_empty_tiles")
	_tiles_trigered = true
