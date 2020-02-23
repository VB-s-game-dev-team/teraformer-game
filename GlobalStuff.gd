extends Node

class_name GlobalStuff

var _screen: Node = null

func _ready() -> void:
	set_screen("TitleScreen")

#Swith to a new screen
# The active one is deleted
# "" as a parameter closes the game
func set_screen(path: String) -> void:
	if _screen != null:
		remove_child(_screen)
		_screen.call_deferred("free")
	
	if path == "":
		call_deferred("_quit")
		return
	
	var screen_resource := load("res://" + path + "/" + path + ".tscn") as PackedScene
	_screen = screen_resource.instance() as Node
	add_child(_screen)

func _quit() -> void:
	get_tree().quit()
