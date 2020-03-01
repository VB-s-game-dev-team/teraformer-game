extends Control

onready var global_stuff: GlobalStuff
onready var ResourcesBar = $MainContainer/Header/ResourcesBar
onready var BuildingDialog = $BuildingDialog
onready var BuildingSpots = $MainContainer/PlanetContainer/ViewportContainer/Viewport/PlanetRotationNode/BuildingSpots

const building_spot_names = [
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

const building_descriptions = [
	"SomeDescription1", 
	"SomeDescription2",
	"SomeDescription3",
	"SomeDescription4",
	"SomeDescription5",
	"SomeDescription6",
	"Suicide Drone Lab Description",
	"Drill Dome Description",
	"Big Bomb Factory Description",
	"SomeDescription10",
	"SomeDescription11",
	"SomeDescription12",
	"SomeDescription13",
	"SomeDescription14",
	"SomeDescription15",
	"SomeDescription16",
	"SomeDescription17",
	"SomeDescription18"
]

const img_path := "res://Planet/building_spot/building_images/"
const img_suffix := ".png"
var building_images := []

const upgrade_cost_increase_rate := 1.2  # should be added to global stuff later
var building_prices := [
	0, 0, 0, 0, 0, 0,
	1000, 2000, 5000, 0,
	0, 0, 0, 0,
	0, 0, 0, 0
]

# Ready
func _ready() -> void:
	global_stuff = get_parent() as GlobalStuff
	
	# Value for testing
	global_stuff.cosmic_credits_count = 5000
	
	ResourcesBar.setup(global_stuff)
	
	building_images.resize(len(building_spot_names))
	for i in range(len(building_spot_names)):
		building_images[i] = load(img_path + building_spot_names[i] + img_suffix)

# Process
func _process(delta: float) -> void:
	pass
	
func _on_MainMenuButton_button_up() -> void:
	global_stuff.set_screen("TitleScreen")
	
func _on_MineButton_button_down() -> void:
	pass # Replace with function body.

func _on_BattleButton_button_down() -> void:
	pass # Replace with function body.

func _on_TRButton_button_down() -> void:
	pass # Replace with function body.

func _on_ShopButton_button_down() -> void:
	pass # Replace with function body.


