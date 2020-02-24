extends Control

onready var BuyMenu = $BuyMenu

func _on_BuyButton_button_up() -> void:
	get_tree().paused = true
	pause_mode = Node.PAUSE_MODE_PROCESS
	BuyMenu.visible = true

func _on_CloseButton_button_up() -> void:
	get_tree().paused = false
	pause_mode = Node.PAUSE_MODE_STOP
	BuyMenu.visible = false
