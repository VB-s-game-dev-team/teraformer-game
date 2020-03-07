extends Control

onready var Planet := self.get_owner()

onready var LeftRotateButton := Planet.get_node("MainContainer/PlanetContainer/LeftRotateButton")
onready var RightRotateButton := Planet.get_node("MainContainer/PlanetContainer/RightRotateButton")

# Variables
var _station_idx := -1
var _station_name: String
var _station_price: int
var _station_level: int
var _station_required_level: int

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

func _open_dialog_window(idx: int) -> void:
	_station_idx = idx
	_set_window_contents()
	_switch_dialog_to(true)

# Opens / closes the dialog	
func _switch_dialog_to(on: bool) -> void:
	LeftRotateButton.visible = !on
	RightRotateButton.visible = !on
	visible = on

#####################################################
func _on_StationDialogCloseButton_pressed() -> void:
	_switch_dialog_to(false)

func _on_MineButton_pressed() -> void:
	_open_dialog_window(StationType.MINE)

func _on_BattleButton_pressed() -> void:
	_open_dialog_window(StationType.BATTLE)

func _on_TRButton_pressed() -> void:
	_open_dialog_window(StationType.TR)



