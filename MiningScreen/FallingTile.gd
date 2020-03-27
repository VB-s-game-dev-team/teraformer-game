extends Sprite

class_name FallingTile

signal done(data)

var _data: Dictionary

func setup(data: Dictionary, color: int, from: Vector2, to: Vector2):
	_data = data
	region_rect.position.x = (color - GameBoard.tiles.YELLOW) * 16
	position = from
	$Tween.interpolate_property(self, "position", from, to, 0.2, \
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_all_completed() -> void:
	emit_signal("done", _data)
	call_deferred("free")
