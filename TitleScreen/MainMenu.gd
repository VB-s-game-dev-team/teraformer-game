extends MarginContainer

var _global_stuff: GlobalStuff

func _ready() -> void:
	_global_stuff = get_parent() as GlobalStuff

func _on_QuitButton_pressed() -> void:
	_global_stuff.set_screen("")

func _on_PlayButton_pressed() -> void:
	_global_stuff.set_screen("Planet")
