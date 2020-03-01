extends Control

var selected_idx = -1
var _selected_price: int
var _selected_name: String
var _selected_description: String

onready var Planet := get_parent().get_parent().get_parent()
onready var BuildingSpots := get_parent().get_node("ViewportContainer/Viewport/PlanetRotationNode/BuildingSpots")

var _info_text := "Do you want to buy this building? \nName: %s \nPrice: %s \nDescription: %s"

func _ready() -> void:
	for bs in BuildingSpots.get_children():
		bs.connect("open_buy_menu", self, "_on_BuildingSpot_open_buy_menu")
		
func _set_building_variables():
	_selected_price = Planet.building_prices[selected_idx]
	_selected_name = Planet.building_spot_names[selected_idx]
	_selected_description = Planet.building_descriptions[selected_idx]
	$BuildingInfo.text = _info_text % [_selected_name, _selected_price, _selected_description]

# Opening the buy menu
func _on_BuildingSpot_open_buy_menu(idx) -> void:
	selected_idx = idx
	$BuildingInfo.visible = true
	_set_building_variables()
	get_parent().get_node("ViewportContainer/Viewport/PlanetRotationNode").visible = false
	visible = true

func _on_BuildingDialogCloseButton_pressed() -> void:
	selected_idx = -1
	$BuildingInfo.visible = false
	get_parent().get_node("ViewportContainer/Viewport/PlanetRotationNode").visible = true
	visible = false

func _on_BuildingDialogAcceptButton_pressed() -> void:
	var ccc = Planet.global_stuff.cosmic_credits_count as int
	if _selected_price <= ccc:
		Planet.global_stuff.cosmic_credits_count = ccc - _selected_price
		BuildingSpots.get_child(selected_idx).texture = Planet.building_images[selected_idx]
		Planet.building_prices[selected_idx] *= Planet.upgrade_cost_increase_rate
		Planet.global_stuff.set_building_level(selected_idx, Planet.global_stuff.get_building_level(selected_idx) + 1)
		visible = false
	else:
		$NotEnoughMessage.visible = true
