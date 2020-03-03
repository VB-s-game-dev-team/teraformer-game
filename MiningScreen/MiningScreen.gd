extends MarginContainer

signal game_started
signal setup(global_stuff)

var _global_stuff: GlobalStuff

func _ready() -> void:
	_global_stuff = get_parent() as GlobalStuff
	emit_signal("setup", _global_stuff)
	call_deferred("_start_game")

func _on_BackButton_pressed():
	_global_stuff.set_screen("Planet")

func _start_game() -> void:
	emit_signal("game_started")
