extends Control

onready var global_stuff: GlobalStuff
onready var ResourcesBar = $MainContainer/Header/ResourcesBar
onready var BuildingDialog = $BuildingDialog
onready var BuildingSpots = $MainContainer/PlanetContainer/ViewportContainer/Viewport/PlanetRotationNode/BuildingSpots

const img_path := "res://Planet/building_spot/building_images/"
const img_suffix := ".png"
var building_images := []

#var building_data: Dictionary

var building_spot_names: Array
var building_descriptions: Array
var building_level_requirements: Array
var building_prices: Array

# Ready
func _ready() -> void:
	global_stuff = get_parent() as GlobalStuff
	
	# Values for testing
	global_stuff.level = 1
	global_stuff.cosmic_credits_count = 5000
	
	_setup_building_data()
	
	ResourcesBar.setup(global_stuff)
	
	for i in range(len(BuildingSpots.get_children())):
		BuildingSpots.get_child(i).building_idx = i
	
	building_images.resize(len(building_spot_names))
	for i in range(len(building_spot_names)):
		building_images[i] = load(img_path + building_spot_names[i] + img_suffix)

# Setup the building data
func _setup_building_data() -> void:
	var file = File.new()
	file.open("res://Planet/building_data.json", File.READ)
	var text = file.get_as_text()
	var building_data = parse_json(text)
	file.close()
	
	building_spot_names = building_data["building_spot_names"]
	building_descriptions = building_data["building_descriptions"]
	building_level_requirements = building_data["building_level_requirements"]
	building_prices = building_data["building_prices"]

# Process
func _process(delta: float) -> void:
	pass
	
func _on_MainMenuButton_button_up() -> void:
	global_stuff.set_screen("TitleScreen")
	
func _on_MineButton_button_down() -> void:
	
	# Handle all of the bonuses, power-ups and other parameters
	# (if needed)
	# In the future
	
	global_stuff.set_screen("MiningScreen")

func _on_BattleButton_button_down() -> void:
	pass # Replace with function body.

func _on_TRButton_button_down() -> void:
	pass # Replace with function body.

func _on_ShopButton_button_down() -> void:
	pass # Replace with function body.
