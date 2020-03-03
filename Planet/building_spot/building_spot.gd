extends Control

var _global_stuff: GlobalStuff
onready var Planet := self.owner
onready var BuyMenu = $BuyMenu

var building_idx: int

signal open_buy_menu(name)

func _ready() -> void:
	pass

func _on_BuyButton_button_up() -> void:
	emit_signal("open_buy_menu", building_idx)
