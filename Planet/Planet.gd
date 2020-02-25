extends Control

onready var _global_stuff: GlobalStuff
onready var ResourcesBar = $MainContainer/Header/ResourcesBar
onready var BuildingDialog = $BuildingDialog
onready var BuildingSpots = $MainContainer/PlanetContainer/ViewportContainer/Viewport/PlanetRotationNode/BuildingSpots

const _building_spot_names = [
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
]

var selected_idx := -1  # Selected building to build

const img_path := "res://Planet/building_spot/building_images/"
const img_suffix := ".png"
var _building_images := []

const _upgrade_cost_increase_rate := 1.2  # should be added to global stuff later
var _building_prices := [
	0, 0, 0, 0, 0, 0,
	1000, 2000, 5000, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
]

# Ready
func _ready() -> void:
	_global_stuff = get_parent() as GlobalStuff
	ResourcesBar.setup(_global_stuff)
	
	_building_images.resize(len(_building_spot_names))
	for i in range(len(_building_spot_names)):
		_building_images[i] = load(img_path + _building_spot_names[i] + img_suffix)
	
	for bs in BuildingSpots.get_children():
		bs.connect("open_buy_menu", self, "_on_BuildingSpot_open_buy_menu")
	
# Process
func _process(delta: float) -> void:
	pass
	
func _on_MainMenuButton_button_up() -> void:
	_global_stuff.set_screen("TitleScreen")
	
func _on_MineButton_button_down() -> void:
	pass # Replace with function body.

func _on_BattleButton_button_down() -> void:
	pass # Replace with function body.

func _on_TRButton_button_down() -> void:
	pass # Replace with function body.

func _on_ShopButton_button_down() -> void:
	pass # Replace with function body.

# Opening the buy menu
func _on_BuildingSpot_open_buy_menu(idx) -> void:
	selected_idx = idx
	BuildingDialog.visible = true

func _on_BuildingDialogCloseButton_pressed() -> void:
	selected_idx = -1
	BuildingDialog.visible = false

func _on_BuildingDialogAcceptButton_button_up() -> void:
	var price := _building_prices[selected_idx] as int
	var ccc := _global_stuff.cosmic_credits_count
	if price <= ccc:
		_global_stuff.cosmic_credits_count = ccc - price
		BuildingSpots.get_child(selected_idx).texture = _building_images[selected_idx]
		_building_prices[selected_idx] *= _upgrade_cost_increase_rate
		_global_stuff.set_building_level(selected_idx, _global_stuff.get_building_level(selected_idx) + 1)
		BuildingDialog.visible = false
	else:
		$BuyMenu/NotEnoughMessage.visible = true
