extends Control

# Node references
onready var global_stuff: GlobalStuff
onready var ResourcesBar = $MainContainer/Header/ResourcesBar
onready var BuildingDialog = $BuildingDialog
onready var BuildingSpots = $MainContainer/PlanetContainer/ViewportContainer/Viewport/PlanetRotationNode/BuildingSpots

# Building images
const img_path := "res://Planet/building_spot/building_images/"
const img_suffix := ".png"
var building_images := []

# All the building data
var building_spot_names: Array
var building_descriptions: Array
var building_level_requirements: Array
var building_prices: Array

# All the station data
var station_names: Array
var station_level_requirements: Array
var station_prices: Array

# Ready
func _ready() -> void:
	global_stuff = get_parent() as GlobalStuff
	
	#############################################
	# VALUES FOR TESTING (also for setup - some)
	global_stuff.level = 1
	global_stuff.cosmic_credits_count = 5000
	for i in range(18):
		global_stuff.set_building_level(i, 0)
	for i in range(3):
		global_stuff.set_station_level(i, 1)
	#############################################
	
	_setup_building_data()
	
	for i in range(len(BuildingSpots.get_children())):
		BuildingSpots.get_child(i).building_idx = i
	
	building_images.resize(len(building_spot_names))
	for i in range(len(building_spot_names)):
		building_images[i] = load(img_path + building_spot_names[i] + img_suffix)

# Setup the building and station data
# All the data is located inside .json files in the Planet directory
# At a later stage, these might need to be moved into res folder, if
# Used by other scenes as well. For now, they remain here.
func _setup_building_data() -> void:
	var file = File.new()
	
	file.open("res://Planet/building_data.json", File.READ)
	var text1 = file.get_as_text()
	var building_data = parse_json(text1)
	
	file.open("res://Planet/station_data.json", File.READ)
	var text2 = file.get_as_text()
	var station_data = parse_json(text2)
	
	file.close()
	
	building_spot_names = building_data["building_spot_names"]
	building_descriptions = building_data["building_descriptions"]
	building_level_requirements = building_data["building_level_requirements"]
	building_prices = building_data["building_prices"]
	
	station_names = station_data["station_names"]
	station_level_requirements = station_data["station_level_requirements"]
	station_prices = station_data["station_prices"]

# Process
func _process(delta: float) -> void:
	pass
	
func _on_MainMenuButton_button_up() -> void:
	global_stuff.set_screen("TitleScreen")

func _on_ShopButton_button_down() -> void:
	pass # Replace with function body.
