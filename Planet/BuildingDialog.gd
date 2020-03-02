extends Control

# Variables pulled from elsewhere and used here
var selected_idx = -1
var _selected_price: int
var _selected_name: String
var _selected_description: String
var _selected_required_level: int
var _selected_my_level: int

# Other nodes
onready var Planet := get_parent().get_parent().get_parent()
onready var BuildingSpots := get_parent().get_node("ViewportContainer/Viewport/PlanetRotationNode/BuildingSpots")

onready var BuildingInfo1 := $BuildingInfo1
onready var BuildingInfo2 := $BuildingInfo2

onready var NotEnoughMoneyMessage := $BuyMenu/NotEnoughMoneyMessage
onready var NotEnoughLevelMessage := $BuyMenu/NotEnoughLevelMessage
onready var MaxLevelMessage := $BuyMenu/MaxLevelMessage

# Info text strings
var _info_text1 := "Do you wish to buy this building? \nName: %s \nDescription: %s"
var _info_text2 := "Price: %s \nRequired level: %s \n%s"

# Ready
func _ready() -> void:
	for bs in BuildingSpots.get_children():
		bs.connect("open_buy_menu", self, "_on_BuildingSpot_open_buy_menu")

# Setting all the variables from elsewhere		
func _set_building_variables() -> void:
	_selected_price = Planet.building_prices[selected_idx]
	_selected_name = Planet.building_spot_names[selected_idx]
	_selected_description = Planet.building_descriptions[selected_idx]
	_selected_my_level = Planet.global_stuff.get_building_level(selected_idx)
	
	if len(Planet.building_level_requirements[selected_idx]) > _selected_my_level + 1:
		_selected_required_level = Planet.building_level_requirements[selected_idx][_selected_my_level + 1]
	else:
		_selected_required_level = -1  # Means max level

# Setting building info text
func _set_building_info_text() -> void:
	BuildingInfo1.text = _info_text1 % [_selected_name, _selected_description]
	var is_max := _selected_required_level == -1
	var price_text := "-" if is_max else str(_selected_price)
	var level_req_text := "-" if is_max else str(_selected_required_level)
	var upgrading_text := "-" if is_max else "from level %s to %s" % [_selected_my_level, _selected_my_level + 1]
	var action_text := " " if _selected_my_level == 0 else "Upgrading: " + upgrading_text
	BuildingInfo2.text = _info_text2 % [price_text, level_req_text, action_text]

# Opening the buy menu
func _on_BuildingSpot_open_buy_menu(idx) -> void:
	selected_idx = idx
	_set_building_variables()
	_set_building_info_text()
	_switch_dialog_to(true)

# Closing the menu
func _on_BuildingDialogCloseButton_pressed() -> void:
	selected_idx = -1
	_switch_dialog_to(false)
	NotEnoughMoneyMessage.visible = false
	NotEnoughLevelMessage.visible = false
	MaxLevelMessage.visible = false

# Buying the building
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

# Checks the required level and price, also max level
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

# Opens / closes the dialog	
func _switch_dialog_to(on: bool) -> void:
	get_parent().get_node("LeftRotateButton").visible = !on
	get_parent().get_node("RightRotateButton").visible = !on
	BuildingInfo1.visible = on
	BuildingInfo2.visible = on
	get_parent().get_node("ViewportContainer/Viewport/PlanetRotationNode").visible = !on
	visible = on

# Different buying possibilities that can occur
enum Buying {POSSIBLE, NOT_ENOUGH_CC, NOT_ENOUGH_LVL, MAX_LVL}
