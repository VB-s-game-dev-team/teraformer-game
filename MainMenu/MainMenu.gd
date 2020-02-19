extends MarginContainer

func _on_QuitButton_pressed():
	call_deferred("quit")

func quit():
	get_tree().quit()
