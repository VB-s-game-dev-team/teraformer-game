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

export(float) var _tile_size: float

var _min_x: int
var _min_y: int
var _max_x: int
var _max_y: int

var _stone_generator := OpenSimplexNoise.new()

var _mouse_transform := Rect2(0, 0, 1, 1)

var _falling_tile_resource: PackedScene

var tiles_waiting_for_fall = []


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
			_break_tile(int(pos.x), int(pos.y))
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
	
	set_cell(x, y, v)
	if v < 0:
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
		
		emit_signal("bounds_updated", \
			_min_x * _tile_size, (_max_x + 1) * _tile_size, \
			_min_y * _tile_size, (_max_y + 1) * _tile_size)

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

func _begin_fall(x: int, y: int, only_down: bool = false) -> bool:
	var falling_tile_x: int
	var falling_tile_y: int
	var falling_tile_color: int
	
	if get_cell(x, y) >= 0 or get_cell(x, y) == tiles.RESERVED:
		tiles_waiting_for_fall.append({"x": x, "y": y})
		return false
	
	if y == 0:
		falling_tile_x = x
		falling_tile_y = -1
		falling_tile_color = \
			tiles.YELLOW + randi() % (tiles.BLUE - tiles.YELLOW + 1)
	else:
		var cell_above: int =  get_cell(x, y - 1)
		#I will refactor this abomination later YELLOW <= color => BLUE
		if cell_above  >= tiles.YELLOW and cell_above <= tiles.BLUE:
			falling_tile_x = x
			falling_tile_y = y - 1
		elif not only_down:
			cell_above = get_cell(x - 1, y - 1)
			if cell_above  >= tiles.YELLOW and cell_above <= tiles.BLUE:
				falling_tile_x = x - 1
				falling_tile_y = y - 1
			else:
				cell_above = get_cell(x + 1, y - 1)
				if cell_above  >= tiles.YELLOW and cell_above <= tiles.BLUE:
					falling_tile_x = x + 1
					falling_tile_y = y - 1
				else:
					tiles_waiting_for_fall.append({"x": x, "y": y})
					return false
		else:
			tiles_waiting_for_fall.append({"x": x, "y": y})
			return false
		falling_tile_color = get_cell(falling_tile_x, falling_tile_y)
		_begin_fall(falling_tile_x, falling_tile_y)
				
	var falling_tile := _falling_tile_resource.instance()
	_set_tile(falling_tile_x, falling_tile_y, tiles.EMPTY)
	_set_tile(x, y, tiles.RESERVED)
	add_child(falling_tile)
	falling_tile.setup( \
		{"x": x, "y": y, "color": falling_tile_color, "node": falling_tile}, \
		falling_tile_color, \
		Vector2(falling_tile_x * _tile_size, falling_tile_y * _tile_size), \
		Vector2(x * _tile_size, y * _tile_size))
	falling_tile.connect("done", self, "_end_fall")
	return true

func _end_fall(data) -> void:
	_set_tile(data.x, data.y, data.color)
	remove_child(data.node)
	data.node.call_deferred("free")
	call_deferred("_trigger_empty_tiles")

func _trigger_empty_tiles() -> void:
	var tmp = tiles_waiting_for_fall
	#var something_happened: bool = false
	tiles_waiting_for_fall = []
	while tmp.size() > 0:
		var coords = tmp.pop_back()
		#something_happened = \
		#	something_happened or 
		_begin_fall(coords.x, coords.y, true)
	
	#if something_happened:
	#	return
	
	tmp = tiles_waiting_for_fall
	tiles_waiting_for_fall = []
	while tmp.size() > 0:
		var coords = tmp.pop_back()
		_begin_fall(coords.x, coords.y)
