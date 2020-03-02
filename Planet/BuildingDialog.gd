extends Control

var selected_idx = -1
var _selected_price: int
var _selected_name: String
var _selected_description: String

onready var Planet := get_parent().get_parent().get_parent()
onready var BuildingSpots := get_parent().get_node("ViewportContainer/Viewport/PlanetRotationNode/BuildingSpots")

onready var BuildingInfo := $BuildingInfo

onready var NotEnoughMoneyMessage := $BuyMenu/NotEnoughMoneyMessage
onready var NotEnoughLevelMessage := $BuyMenu/NotEnoughLevelMessage
onready var MaxLevelMessage := $BuyMenu/MaxLevelMessage

var _info_text := "Do you wish to buy this building? \nName: %s \nPrice: %s \nDescription: %s"

func _ready() -> void:
	for bs in BuildingSpots.get_children():
		bs.connect("open_buy_menu", self, "_on_BuildingSpot_open_buy_menu")
		
func _set_building_variables():
	_selected_price = Planet.building_prices[selected_idx]
	_selected_name = Planet.building_spot_names[selected_idx]
	_selected_description = Planet.building_descriptions[selected_idx]
	BuildingInfo.text = _info_text % [_selected_name, _selected_price, _selected_description]

# Opening the buy menu
func _on_BuildingSpot_open_buy_menu(idx) -> void:
	selected_idx = idx
	_set_building_variables()
	_switch_dialog_to(true)

func _on_BuildingDialogCloseButton_pressed() -> void:
	selected_idx = -1
	_switch_dialog_to(false)
	NotEnoughMoneyMessage.visible = false
	NotEnoughLevelMessage.visible = false
	MaxLevelMessage.visible = false

func _on_BuildingDialogAcceptButton_pressed() -> void:
	match _is_required_level_and_price():
		Buying.POSSIBLE:
			Planet.global_stuff.cosmic_credits_count = Planet.global_stuff.cosmic_credits_count - _selected_price
			BuildingSpots.get_child(selected_idx).get_node("BuildingSpotTexture").texture = Planet.building_images[selected_idx]
			Planet.building_prices[selected_idx] *= Planet.upgrade_cost_increase_rate
			Planet.global_stuff.set_building_level(selected_idx, Planet.global_stuff.get_building_level(selected_idx) + 1)
			_switch_dialog_to(false)
		Buying.NOT_ENOUGH_CC:
			NotEnoughMoneyMessage.visible = true
		Buying.NOT_ENOUGH_LVL:
			NotEnoughLevelMessage.visible = true
		Buying.MAX_LVL:
			MaxLevelMessage.visible = true
		_:
			print("!ERROR! Buying didn't go as planned !ERROR!")

func _is_required_level_and_price() -> int:
	if Planet.global_stuff.cosmic_credits_count < _selected_price:
		return Buying.NOT_ENOUGH_CC
	var bought_building_level = Planet.global_stuff.get_building_level(selected_idx) + 1 as int 
	if bought_building_level >= len(Planet.building_level_requirements[selected_idx]):
		return Buying.MAX_LVL
	var required_level = Planet.building_level_requirements[selected_idx][bought_building_level] as int
	if Planet.global_stuff.level >= required_level:
		return Buying.POSSIBLE
	else:
		return Buying.NOT_ENOUGH_LVL
		
func _switch_dialog_to(on: bool) -> void:
	get_parent().get_node("LeftRotateButton").visible = !on
	get_parent().get_node("RightRotateButton").visible = !on
	BuildingInfo.visible = on
	get_parent().get_node("ViewportContainer/Viewport/PlanetRotationNode").visible = !on
	visible = on
	
enum Buying {POSSIBLE, NOT_ENOUGH_CC, NOT_ENOUGH_LVL, MAX_LVL}
