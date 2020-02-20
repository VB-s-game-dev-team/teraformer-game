extends Node

var screen

func _ready():
	set_screen("TitleScreen")

func set_screen(path):
	if screen != null:
		remove_child(screen)
		screen.call_deferred("free")
	
	var screen_resource = load("res://" + path + "/" + path + ".tscn")
	screen = screen_resource.instance()
	add_child(screen)
