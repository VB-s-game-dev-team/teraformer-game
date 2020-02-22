extends MarginContainer

var global_stuff: GlobalStuff

func _ready():
	global_stuff = get_parent() as GlobalStuff

func _on_QuitButton_pressed():
	global_stuff.set_screen("")

func _on_PlayButton_pressed():
	global_stuff.set_screen("Planet")
