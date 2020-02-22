extends MarginContainer

func _on_QuitButton_pressed():
	get_parent().set_screen("")

func _on_PlayButton_pressed():
	switch_to_planet()
	
func switch_to_planet():
	get_parent().set_screen("Planet")
