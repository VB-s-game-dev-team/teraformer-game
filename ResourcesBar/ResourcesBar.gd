extends Control

onready var CosmicCreditsValue = $CosmicCreditsValue
onready var StarDustValue = $StarDustValue
onready var LevelValue = $LevelValue
onready var XPValue = $XPValue

func _ready() -> void:
	pass
# Sets the values according to the global variables
# Names like cosmic credits and star dust are temporary, but in any case:
# star dust ... more rare / premium currency
# cosmic credits ... more common currency to buy most stuff
# level and XP ... self-explanatory, acquired by terraforming
# resources ... do not know the types yet
	
