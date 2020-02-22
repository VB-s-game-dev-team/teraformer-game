extends Node

var screen

func _ready():
	set_screen("TitleScreen")

func set_screen(path):
	if screen != null:
		remove_child(screen)
		screen.call_deferred("free")
	
	if path == "":
		call_deferred("quit")
		return
	
	var screen_resource = load("res://" + path + "/" + path + ".tscn")
	screen = screen_resource.instance()
	add_child(screen)

func quit():
	get_tree().quit()
