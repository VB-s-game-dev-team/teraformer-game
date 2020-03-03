extends Control

var _global_stuff: GlobalStuff

onready var CosmicCreditsValue = $MarginContainer/LabelContainer/CosmicCreditsValue
onready var StarDustValue = $MarginContainer/LabelContainer/StarDustValue
onready var LevelValue = $MarginContainer/LabelContainer/LevelValue
onready var XPValue = $MarginContainer/LabelContainer/XPValue

func _ready() -> void:
	pass
	
func setup(g: GlobalStuff) -> void:
	_global_stuff = g
	g.connect("cosmic_credits_count_changed", self, "_update_values")
	g.connect("star_dust_count_changed", self, "_update_values")
	g.connect("experience_changed", self, "_update_values")
	g.connect("level_changed", self, "_update_values")
	_update_values()
	
func _update_values():
	CosmicCreditsValue.text = str(_global_stuff.cosmic_credits_count)
	StarDustValue.text = str(_global_stuff.star_dust_count)
	LevelValue.text = str(_global_stuff.level)
	XPValue.text = str(_global_stuff.experience)
	
# Sets the values according to the global variables
# Names like cosmic credits and star dust are temporary, but in any case:
# star dust ... more rare / premium currency
# cosmic credits ... more common currency to buy most stuff
# level and XP ... self-explanatory, acquired by terraforming
# resources ... do not know the types yet
	
