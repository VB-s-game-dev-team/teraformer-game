extends TileMap



enum _tiles{
	HIDEN = 0,
	YELLOW = 1,
	RED = 2,
	GREEN = 3,
	BLUE = 4,
	DIRT = 5,
	STONE = 6
}

func _on_MiningScreen_game_started() -> void:
	clear()
	for i in range(-50, 50):
		for j in range(-50, 50):
			set_cell(i, j, randi() % 7)
	
