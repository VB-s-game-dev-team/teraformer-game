extends Viewport

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and event.button_mask == BUTTON_RIGHT:
		$Camera2D.offset += event.relative
	elif event is InputEventMouseButton:
		match event.button_index:
			BUTTON_WHEEL_UP:
				var rel: Vector2 = $Camera2D.offset - event.position
				$Camera2D.offset -= rel
				$Camera2D.zoom /= 1.1
				$Camera2D.offset += rel / 1.1
			BUTTON_WHEEL_DOWN: 
				var rel: Vector2 = $Camera2D.offset - event.position
				$Camera2D.offset -= rel
				$Camera2D.zoom *= 1.1
				$Camera2D.offset += rel * 1.1
