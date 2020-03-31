extends Line2D

var selected_color: int setget _set_color, _get_color
var _board: GameBoard

var _colors = {
	GameBoard.tiles.YELLOW: Color(1, 1, 0.4),
	GameBoard.tiles.RED: Color(1, 0.4, 0.4),
	GameBoard.tiles.GREEN: Color(0.4, 1, 0.4),
	GameBoard.tiles.BLUE: Color(0.4, 0.4, 1)
}

func _ready() -> void:
	_board = get_parent() as GameBoard
	position = Vector2(_board.TILE_SIZE, _board.TILE_SIZE) * 0.5
	scale = Vector2(_board.TILE_SIZE, _board.TILE_SIZE)

func _set_color(v: int) -> void:
	selected_color = v
	default_color = _colors[v]
	
func _get_color() -> int:
	return selected_color
