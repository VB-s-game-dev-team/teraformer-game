extends MarginContainer

func _on_QuitButton_pressed():
	call_deferred("quit")

func _on_Button_pressed():
	switch_to_planet()

func quit():
	get_tree().quit()
	
func switch_to_planet():
	get_parent().set_screen("Planet")

