extends Control

var _global_stuff: GlobalStuff

onready var CosmicCreditsValue = $CosmicCreditsValue
onready var StarDustValue = $StarDustValue
onready var LevelValue = $LevelValue
onready var XPValue = $XPValue

func _ready() -> void:
	_global_stuff = get_parent() as GlobalStuff
	CosmicCreditsValue.text = _global_stuff.cosmic_credits_count
	StarDustValue.text = _global_stuff.star_dust_count
	LevelValue.text = _global_stuff.level
	XPValue.text = _global_stuff.experience
	
# Sets the values according to the global variables
# Names like cosmic credits and star dust are temporary, but in any case:
# star dust ... more rare / premium currency
# cosmic credits ... more common currency to buy most stuff
# level and XP ... self-explanatory, acquired by terraforming
# resources ... do not know the types yet
	
