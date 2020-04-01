extends Line2D

var selected_color: int = -1 setget _set_color, _get_color
var _board: GameBoard

var _colors = {
	GameBoard.tiles.YELLOW: Color(1, 1, 0.4),
	GameBoard.tiles.RED: Color(1, 0.4, 0.4),
	GameBoard.tiles.GREEN: Color(0.4, 1, 0.4),
	GameBoard.tiles.BLUE: Color(0.2, 0.4, 1)
}

func _ready() -> void:
	_board = get_parent() as GameBoard
	position = Vector2(_board.TILE_SIZE, _board.TILE_SIZE) * 0.5
	scale = Vector2(_board.TILE_SIZE, _board.TILE_SIZE)
	
# quick note to myself:
#	this is VERY bad, because it gets called on every frame for no good reason
#   except my laziness -> needs to get refactored later
func _process(_delta: float) -> void:
	if selected_color != -1:
		if get_point_count() < _board.MIN_CHAIN_LENGTH:
			default_color = _colors[selected_color] * Color(1, 1, 1, 0.5)
		else:
			default_color = _colors[selected_color]

func _set_color(v: int) -> void:
	selected_color = v
	default_color = _colors[v] * Color(1, 1, 1, 0.5)
	
func _get_color() -> int:
	return selected_color

