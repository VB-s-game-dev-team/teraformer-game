extends MarginContainer

var _global_stuff: GlobalStuff

func _ready() -> void:
	_global_stuff = get_parent() as GlobalStuff

func _on_BackButton_pressed():
	_global_stuff.set_screen("Planet")
