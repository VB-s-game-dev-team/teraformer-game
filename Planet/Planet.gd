extends Control

onready var _global_stuff: GlobalStuff

# Rotation variables
onready var ResourcesBar = $MainContainer/Header/ResourcesBar

# Ready
func _ready() -> void:
	_global_stuff = get_parent() as GlobalStuff
	ResourcesBar.setup(_global_stuff)
	
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


