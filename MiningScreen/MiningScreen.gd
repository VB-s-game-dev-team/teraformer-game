extends MarginContainer

signal game_started
signal setup(global_stuff)

var _global_stuff: GlobalStuff

func _ready() -> void:
	_global_stuff = get_parent() as GlobalStuff
	emit_signal("setup", _global_stuff)
	emit_signal("game_started")

func _on_BackButton_pressed():
	_global_stuff.set_screen("Planet")
