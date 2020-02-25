extends Control

var _global_stuff: GlobalStuff

const _upgrade_cost_increase_rate := 1.2
const building_names := [
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
	"Building18",
]

const img_path := "res://Planet/building_spot/building_images/"
const img_suffix := ".png"

var _building_images := []

signal open_buy_menu()

var _building_prices := [
	0, 0, 0, 0, 0, 0,
	1000, 2000, 5000, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
]

onready var BuyMenu = $BuyMenu

func _ready() -> void:
	_global_stuff = get_parent() as GlobalStuff
	_building_images.resize(len(building_names))
	for i in range(len(building_names)):
		_building_images[i] = load(img_path + building_names[i] + img_suffix)

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
		_global_stuff.cosmic_credits_count = ccc - price
		$BuildingSpotTexture.texture = _building_images[options.selected]
		_building_prices[options.selected] *= _upgrade_cost_increase_rate
		
		# Future change of said variable
		# _global_stuff.building_level[options.selected] += 1
		
		BuyMenu.visible = false
	else:
		$BuyMenu/NotEnoughMessage.visible = true
