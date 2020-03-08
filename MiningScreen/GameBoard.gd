extends TileMap

class_name GameBoard

signal bounds_updated(min_x, max_x, min_y, max_y)

enum tiles{
	RESERVED = -3,
	EMPTY = -2,
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

export(float) var _tile_size: float

var _min_x: int
var _min_y: int
var _max_x: int
var _max_y: int

var _stone_generator := OpenSimplexNoise.new()

var _mouse_transform := Rect2(0, 0, 1, 1)

var _falling_tile_resource: PackedScene

func _ready() -> void:
	_falling_tile_resource = load("res://MiningScreen/FallingTile.tscn")
	
	_stone_generator.seed = randi()
	_stone_generator.octaves = 1
	_stone_generator.period = 5

func _input(event: InputEvent) -> void:
	var pos: Vector2
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		pos = _tile_pos(_transform_mouse_pos(event.position))
	
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed \
			and get_cellv(pos) != tiles.HIDEN:
			#warning-ignore:narrowing_conversion 
			#warning-ignore:narrowing_conversion
			_break_tile(pos.x, pos.y)
			print(pos)

func _on_MiningScreen_game_started() -> void:
	clear()
	for i in range(0, _INIT_SIZE):
		for j in range(0, _INIT_SIZE):
			_break_tile(i, j)

func _random_color() -> int:
	return randi() % 4 + tiles.YELLOW

func _break_tile(x: int, y: int) -> void:
	for i in range(x - 1, x + 2):
		for j in range(y - 1, y + 2):
			_uncover_tile(i, j)
	_set_tile(x, y, tiles.EMPTY)

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
	
	if v == tiles.EMPTY:
		_begin_fall(x, y)
	
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
		
		emit_signal("bounds_updated", _min_x * _tile_size, (_max_x + 1) * _tile_size, 
			_min_y * _tile_size, (_max_y + 1) * _tile_size)
		
	
	set_cell(x, y, v)

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
		pos.x -= _tile_size
	if pos.y < 0:
		pos.y -= _tile_size
	return pos / _tile_size

func _on_BoardCamera_transform_changed(t) -> void:
	_mouse_transform = t

func _begin_fall(x: int, y: int) -> void:
	var falling_tile := _falling_tile_resource.instance()
	add_child(falling_tile)
	falling_tile.setup(0, tiles.BLUE, \
		Vector2(x * _tile_size, y * _tile_size), \
		Vector2(x * _tile_size, (y + 1) * _tile_size))
