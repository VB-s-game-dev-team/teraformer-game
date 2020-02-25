extends Control

var _global_stuff: GlobalStuff

const _upgrade_cost_increase_rate := 1.2
export(
	int, 
	"Building1", 
	"Building2",
	"Building3",
	"Building4",
	"Building5",
	"Building6",
	"Suicide Drone Lab",
	"Drill Dome",
	"Big Bomb Factory",
	"Building10",
	"Building11",
	"Building12",
	"Building13",
	"Building14",
	"Building15",
	"Building16",
	"Building17",
	"Building18"
) var building_names

onready var BuyMenu = $BuyMenu

signal open_buy_menu(name)

func _ready() -> void:
	pass

func _on_BuyButton_button_up() -> void:
	emit_signal("open_buy_menu", building_names)

# Buying the selected building
#func _on_AcceptButton_button_up() -> void:
#	var options = $BuyMenu/BuildingOptions
#	var price := _building_prices[options.selected] as int
#	var ccc := _global_stuff.cosmic_credits_count
#	if price <= ccc:
#		_global_stuff.cosmic_credits_count = ccc - price
#		$BuildingSpotTexture.texture = _building_images[options.selected]
#		_building_prices[options.selected] *= _upgrade_cost_increase_rate
#
#		# Future change of said variable
#		# _global_stuff.building_level[options.selected] += 1
#
#		BuyMenu.visible = false
#	else:
#		$BuyMenu/NotEnoughMessage.visible = true
