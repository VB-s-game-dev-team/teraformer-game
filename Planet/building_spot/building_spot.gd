extends Control

var _global_stuff: GlobalStuff

const _upgrade_cost_increase_rate := 1.2
const building_names := {
	0: "Building1",
	1: "Building2",
	2: "Building3",
	3: "Building4",
	4: "Building5",
	5: "Building6",
	6: "Suicide Drone Lab",
	7: "Drill Dome",
	8: "Big Bomb Factory",
	9: "Building10",
	10: "Building11",
	11: "Building12",
	12: "Building13",
	13: "Building14",
	14: "Building15",
	15: "Building16",
	16: "Building17",
	17: "Building18",
}
var _building_prices := [
	0, 0, 0, 0, 0, 0,
	1000, 2000, 5000, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
]

onready var BuyMenu = $BuyMenu

func _ready() -> void:
	_global_stuff = get_parent() as GlobalStuff

func _on_BuyButton_button_up() -> void:
	get_tree().paused = true
	pause_mode = Node.PAUSE_MODE_PROCESS
	BuyMenu.visible = true

func _on_CloseButton_button_up() -> void:
	get_tree().paused = false
	pause_mode = Node.PAUSE_MODE_STOP
	BuyMenu.visible = false

# Buying the selected building
func _on_AcceptButton_button_up() -> void:
	var options = $BuyMenu/BuildingOptions
	var price := _building_prices[options.selected] as int
	var ccc := _global_stuff.cosmic_credits_count
	if price <= ccc:
		_global_stuff._set_cosmic_credits_count(ccc - price)
		$BuildingSpotTexture.texture = \
		load("res://Planet/building_spot/building_images/" + \
		building_names[options.selected] + ".png")
		_building_prices[options.selected] *= _upgrade_cost_increase_rate
		
		# Future change of said variable
		# _global_stuff.building_level[options.selected] += 1
		
		BuyMenu.visible = false
	else:
		$BuyMenu/NotEnoughMessage.visible = true
