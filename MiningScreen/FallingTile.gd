extends Sprite

class_name FallingTile

signal done(id)

var _id: int

func setup(id: int, color: int, from: Vector2, to: Vector2):
	_id = id
	region_rect.position.x = (color - GameBoard.tiles.YELLOW) * 16
	position = from
	$Tween.interpolate_property(self, "position", from, to, 0.5, \
		Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_all_completed() -> void:
	emit_signal("done", _id)
	call_deferred("free")
