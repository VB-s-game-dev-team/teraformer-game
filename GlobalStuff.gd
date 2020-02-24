extends Node

class_name GlobalStuff

var screen: Node = null

func _ready():
	set_screen("TitleScreen")

# Switch to a new screen
# The active one is deleted
# "" as a parameter closes the game
func set_screen(path: String):
	if screen != null:
		remove_child(screen)
		screen.call_deferred("free")
	
	if path == "":
		call_deferred("quit")
		return
	
	var screen_resource = load("res://" + path + "/" + path + ".tscn") as PackedScene
	screen = screen_resource.instance() as Node
	add_child(screen)

func quit():
	get_tree().quit()
