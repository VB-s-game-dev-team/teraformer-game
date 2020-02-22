extends Control

onready var BuyMenu = $BuyMenu

func _on_BuyButton_button_up() -> void:
	BuyMenu.visible = true

func _on_CloseButton_button_up() -> void:
	BuyMenu.visible = false
