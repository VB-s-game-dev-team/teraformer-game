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

func _ready() -> void:
	_stone_generator.seed = randi()
	_stone_generator.octaves = 1
	_stone_generator.period = 1

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
	if _min_x > x:
		_min_x = x
		changed = true
	if _max_x < x:
		_max_x = x
		changed = true
	if _min_y > y:
		_min_y = y
		changed = true
	if _max_y < y:
		_max_y = y
		changed = true
	
	if changed:
		emit_signal("bounds_updated", _min_x * _tile_size, (_max_x + 1) * _tile_size, 
			_min_y * _tile_size, (_max_y + 1) * _tile_size)
	
	set_cell(x, y, v)

func _put_random_color(x: int, y: int) -> void:
	_set_tile(x, y, _random_color())
