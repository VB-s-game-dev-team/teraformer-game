extends Control

var _global_stuff: GlobalStuff

onready var CosmicCreditsValue = $CosmicCreditsValue
onready var StarDustValue = $StarDustValue
onready var LevelValue = $LevelValue
onready var XPValue = $XPValue

func _ready() -> void:
	pass
	
func setup(g: GlobalStuff) -> void:
	_global_stuff = g
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
	
