extends TileMap

signal bounds_updated(min_x, max_x, min_y, max_y)

enum _tiles{
	HIDEN = 0,
	YELLOW = 1,
	RED = 2,
	GREEN = 3,
	BLUE = 4,
	DIRT = 5,
	STONE = 6
}

export(int) var _INIT_SIZE: int = 5

export(float) var _tile_size: float

var _min_x: int
var _min_y: int
var _max_x: int
var _max_y: int

var _stone_generator := OpenSimplexNoise.new()

var _mouse_transform := Rect2(0, 0, 1, 1)

func _ready() -> void:
	_stone_generator.seed = randi()
	_stone_generator.octaves = 1
	_stone_generator.period = 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		var pos = _tile_pos(_transform_mouse_pos(event.position))
		_break_tile(pos.x, pos.y)
	

func _on_MiningScreen_game_started() -> void:
	clear()
	for i in range(0, _INIT_SIZE):
		for j in range(0, _INIT_SIZE):
			_break_tile(i, j)

func _random_color() -> int:
	return randi() % 4 + 1

func _break_tile(x: int, y: int) -> void:
	_put_random_color(x, y)
	for i in range(x - 1, x + 2):
		for j in range(y - 1, y + 2):
			_uncover_tile(i, j)

func _uncover_tile(x: int, y: int):
	if get_cell(x, y) == _tiles.HIDEN:
		var tile: int = _tiles.DIRT
		if _stone_generator.get_noise_2d(x, y) > y / 1000.0:
			tile = _tiles.STONE
		_set_tile(x, y, tile)
	for i in range(x - 1, x + 2):
		for j in range(y - 1, y + 2):
			if get_cell(i, j) == -1:
				_set_tile(i, j, _tiles.HIDEN)

func _set_tile(x: int, y: int, v: int) -> void:
	if y < 0:
		return
	
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
			_fix_exposed_tiles(rx, ry)
		
		if changed_y != 0:
			rx = range(_min_x, _max_x + 1)
			if changed_y < 0:
				ry = range(_min_y, _min_y - changed_y + 1)
			else:
				ry = range(_max_y - changed_y + 1, _max_y + 1)
			_fix_exposed_tiles(rx, ry)
		
		emit_signal("bounds_updated", _min_x * _tile_size, (_max_x + 1) * _tile_size, 
			_min_y * _tile_size, (_max_y + 1) * _tile_size)
		
	
	set_cell(x, y, v)

func _fix_exposed_tiles(rx, ry):
	for x in rx:
		for y in ry:
			if get_cell(x, y) == -1:
				#not using _set_tile() to avoid trigering bound update again
				set_cell(x, y, _tiles.HIDEN)

func _put_random_color(x: int, y: int) -> void:
	_set_tile(x, y, _random_color())

func _transform_mouse_pos(pos: Vector2) -> Vector2:
	return pos * _mouse_transform.size.x + _mouse_transform.position

func _tile_pos(pos: Vector2) -> Vector2:
	return pos / _tile_size

func _on_BoardCamera_transform_changed(t) -> void:
	_mouse_transform = t
