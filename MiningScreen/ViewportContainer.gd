extends ViewportContainer

func _gui_input(event: InputEvent) -> void:
	if event.is_type("InputEventMouseMotion"):
		var mouse_button_event := event as InputEventMouseMotion
