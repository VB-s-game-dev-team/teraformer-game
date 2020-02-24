extends Node

class_name GlobalStuff

#global variables
var cosmic_credits_count: int setget _set_cosmic_credits_count
var star_dust_count: int setget _set_star_dust_count
var experience: int setget _set_experience
var level: int setget _set_level


#signals for global variables
signal cosmic_credits_count_changed
signal star_dust_count_changed
signal experience_changed
signal level_changed


var _screen: Node = null

func _ready() -> void:
	_load_state()
	set_screen("TitleScreen")

# Switch to a new screen
# The active one is deleted
# "" as a parameter closes the game
func set_screen(path: String) -> void:
	if _screen != null:
		remove_child(_screen)
		_screen.call_deferred("free")
	
	if path == "":
		call_deferred("_quit")
		return
	
	var screen_resource := load("res://" + path + "/" + path + ".tscn") as PackedScene
	_screen = screen_resource.instance() as Node
	add_child(_screen)

func _quit() -> void:
	_save_state()
	get_tree().quit()

#save/load
func _save_state() -> void:
	var data := {
		"cosmic_credits_count": cosmic_credits_count,
		"star_dust_count": star_dust_count,
		"experience": experience,
		"level": level
	}
	var save_file := File.new()
	save_file.open("user://save.dat", File.WRITE)
	save_file.store_line(to_json(data))
	save_file.close()

func _load_state() -> void:
	var save_file := File.new()
	var data: Dictionary = {}
	
	if not save_file.file_exists("user://save.dat"):
		data = {
			"cosmic_credits_count": 0,
			"star_dust_count": 0,
			"experience": 0,
			"level": 0
		}
	else:
		save_file.open("user://save.dat", File.READ)
		data = parse_json(save_file.get_line())
		save_file.close()
	
	cosmic_credits_count = data["cosmic_credits_count"] as int
	star_dust_count = data["star_dust_count"] as int
	experience = data["experience"] as int
	level = data["level"] as int

#setters and getters
func _set_cosmic_credits_count(v: int) -> void:
	cosmic_credits_count = v
	emit_signal("cosmic_credits_count_changed")

func _set_star_dust_count(v: int) -> void:
	star_dust_count = v
	emit_signal("star_dust_count_changed")

func _set_experience(v: int) -> void:
	experience = v
	emit_signal("experience_changed")

func _set_level(v: int) -> void:
	level = v
	emit_signal("level_changed")
