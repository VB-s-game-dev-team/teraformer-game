extends Control

onready var Planet := self.get_owner()

onready var LeftRotateButton := Planet.get_node("MainContainer/PlanetContainer/LeftRotateButton")
onready var RightRotateButton := Planet.get_node("MainContainer/PlanetContainer/RightRotateButton")

onready var StationInfo1 := $StationMenu/StationInfo1

onready var NotEnoughMoneyMessage := $StationMenu/NotEnoughMoneyMessage
onready var NotEnoughLevelMessage := $StationMenu/NotEnoughLevelMessage
onready var MaxLevelMessage := $StationMenu/MaxLevelMessage

# Variables
var _station_idx := -1
var _station_name: String
var _station_price: int
var _station_level: int
var _station_required_level: int

var _info_text1 := "%s \nPrice: %s \nRequired level: %s \n%s"

# Ready
func _ready() -> void:
	pass

enum StationType {MINE, BATTLE, TR}

func _set_window_contents() -> void:
	_station_name = Planet.station_names[_station_idx]
	_station_level = Planet.global_stuff.get_station_level(_station_idx)
	if len(Planet.station_level_requirements[_station_idx]) > _station_level + 1:
		_station_price = Planet.station_prices[_station_idx][_station_level + 1]
		_station_required_level = Planet.station_level_requirements[_station_idx][_station_level + 1]
	else:
		_station_price = -1  # Means max level
		_station_required_level = -1  # Means max level

func _set_station_info_text():
	var is_max := _station_required_level == -1 or _station_price == -1
	var price_text := "-" if is_max else str(_station_price)
	var level_req_text := "-" if is_max else str(_station_required_level)
	var upgrading_text := "-" if is_max else "from level %s to %s" % [_station_level, _station_level + 1]
	var action_text := " " if _station_level == 0 else "Upgrading: " + upgrading_text
	StationInfo1.text = _info_text1 % [_station_name, price_text, level_req_text, action_text]

func _open_dialog_window(idx: int) -> void:
	_station_idx = idx
	_set_window_contents()
	_set_station_info_text()
	_switch_dialog_to(true)

# Opens / closes the dialog	
func _switch_dialog_to(on: bool) -> void:
	LeftRotateButton.visible = !on
	RightRotateButton.visible = !on
	visible = on

# Different buying possibilities that can occur
enum Buying {POSSIBLE, NOT_ENOUGH_CC, NOT_ENOUGH_LVL, MAX_LVL}

func _is_required_level_and_price() -> int:
	var bought_station_level = Planet.global_stuff.get_station_level(_station_idx) + 1 as int 
	if bought_station_level >= len(Planet.station_level_requirements[_station_idx]):
		return Buying.MAX_LVL
	var required_level = Planet.station_level_requirements[_station_idx][bought_station_level] as int
	if Planet.global_stuff.level >= required_level:
		if Planet.global_stuff.cosmic_credits_count < _station_price:
			return Buying.NOT_ENOUGH_CC
		return Buying.POSSIBLE
	else:
		return Buying.NOT_ENOUGH_LVL

func _on_StationDialogCloseButton_pressed() -> void:
	_station_idx = -1
	_switch_dialog_to(false)
	NotEnoughMoneyMessage.visible = false
	NotEnoughLevelMessage.visible = false
	MaxLevelMessage.visible = false

func _on_MineButton_pressed() -> void:
	_open_dialog_window(StationType.MINE)

func _on_BattleButton_pressed() -> void:
	_open_dialog_window(StationType.BATTLE)

func _on_TRButton_pressed() -> void:
	_open_dialog_window(StationType.TR)

func _on_StationDialogAcceptButton_pressed() -> void:
	match _is_required_level_and_price():
		Buying.POSSIBLE:
			Planet.global_stuff.cosmic_credits_count = Planet.global_stuff.cosmic_credits_count - _station_price
			Planet.global_stuff.set_station_level(_station_idx, Planet.global_stuff.get_station_level(_station_idx) + 1)
			_switch_dialog_to(false)
		Buying.MAX_LVL:
			MaxLevelMessage.visible = true
		Buying.NOT_ENOUGH_LVL:
			NotEnoughLevelMessage.visible = true
		Buying.NOT_ENOUGH_CC:
			NotEnoughMoneyMessage.visible = true
		_:
			print("!ERROR! Something didn't go as planned !ERROR!")
